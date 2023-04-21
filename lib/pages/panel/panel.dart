import 'package:data7_panel/models/tableComponentData.dart';
import 'package:data7_panel/models/transform_data.dart';
import 'package:data7_panel/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

import '../../components/bottom_app_bar.dart';
import '../../components/bottom_sheet_menu.dart';
import '../../components/dialog_alert.dart';
import '../../components/loading_animated.dart';
import '../../components/render_panel.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key, required this.url});
  final String url;
  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  bool _connected = false;
  bool _connecting = false;
  bool _isOpenDialog = false;
  int _manualAttemptsReconnect = 0;
  String _lastTimeSync = '';
  List<TableComponentData> dataPanel = [];
  bool opened = false;
  String _message = "";
  late IO.Socket socket;
  late SocketIOClient newSocket = SocketIOClient();

  bool isConnected = true;
  bool isExpanded = false;
  int selectedFontSizeIndex = 2;

  String _legends = '';

  final List<double> fontSizes = [16, 18, 20, 22];

  final FocusNode _focusNode = FocusNode();
  late FocusAttachment _focusAttachment;

  int escPressedCount = 0;

  late CustomDialogAlert Alert;

  void _initSocketConnection() {
    newSocket.connect(
      url: widget.url,
      onConnectionChange: (isConnected) {
        setState(() {
          _connected = isConnected;
          _connecting = false;
          _manualAttemptsReconnect = 0;
          setState(() {
            if (isConnected) {
              _message = "Conectado, aguardando dados...";
            } else {
              _message =
                  "Desconectado, verifique a conexão com a rede e se o servidor está online.";
            }
          });
        });
      },
      onConnectionError: (error) {
        setState(() {
          _message = error.toString();
        });
      },
      maxReconnectAttempts: 5,
      reconnectAttemptsDelay: 1000,
      onMaxReconnectAttemptsReached: (attempts) {
        _openDialogAlert(attempts);
      },
    );
    newSocket.listen('data_dispath_panel', (data) {
      setState(() {
        _lastTimeSync = inputFormat.format(DateTime.now()).toString();
        dataPanel =
            TransformData().parseData(data.cast<Map<String, dynamic>>());
        setState(() {
          if (dataPanel.isNotEmpty) {
            _legends = dataPanel[0].legendColors;
          }
        });
      });
    });
  }

  void _reconnect() {
    setState(() {
      _connecting = true;
      _manualAttemptsReconnect++;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _connecting = false;
      });
      if (!newSocket.getIsConected()) {
        _openDialogAlert(_manualAttemptsReconnect);
      }
    });
    newSocket.reconnect();
  }

  void _initAlertDialog() {
    Alert = CustomDialogAlert(defaultTitle: "Atenção!", actions: [
      CustomDialogAction(
          label: "Sair",
          onPress: () {
            _closeDialog();
            Navigator.of(context).pop();
          }),
      CustomDialogAction(label: "Aguardar", onPress: _closeDialog),
      CustomDialogAction(
          label: "Reconectar",
          onPress: () {
            _reconnect();
            _closeDialog();
          }),
    ]);
  }

  void _openDialogAlert(int attempts) {
    if (_isOpenDialog) return;
    newSocket.onReconnectedCallback = _closeDialog;
    Alert.show(context, "Atenção!",
        "Painel Desconectado.\nVerifique se o servidor está ativo e disponível no endereço fornececido.\nTentativas de conexão: $attempts");
    _isOpenDialog = true;
  }

  void _closeDialog() {
    newSocket.onReconnectedCallback = null;
    Alert.close(context);
    setState(() {
      _isOpenDialog = false;
    });
  }

  void toggleFontSizeSelector() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _onPressFloatingButtom() {
    _connected ? toggleFontSizeSelector() : _reconnect();
  }

  void _initFocusToKeyEvent() {
    _focusAttachment = _focusNode.attach(context, onKeyEvent: (node, event) {
      setState(() {
        escPressedCount++;
      });
      if (event.logicalKey.keyId == LogicalKeyboardKey.escape.keyId &&
          escPressedCount == 1) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      return KeyEventResult.handled;
    });
    _focusNode.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    _initSocketConnection();
    _initAlertDialog();
    _initFocusToKeyEvent();
  }

  @override
  void dispose() {
    newSocket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _focusAttachment.reparent();
    return Scaffold(
      body: dataPanel.isEmpty
          ? LoadingAnimated(
              message: _message,
            )
          : RenderPanels(
              dataList: dataPanel,
              isHorizontal: dataPanel[0].isHorizontal,
            ),
      bottomNavigationBar: CustomBottomAppBar(
        legends: _legends,
        lastTimeSync: _lastTimeSync,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressFloatingButtom,
        tooltip: _connected ? "Painel Conectado" : "Reconectar",
        backgroundColor: Colors.white,
        child: _connecting
            ? const CircularProgressIndicator()
            : Icon(
                Icons.connected_tv_outlined,
                size: 40,
                color: _connected ? Colors.green : Colors.red,
              ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomSheet: isExpanded ? const BottomSheetMenu() : null,
    );
  }
}
