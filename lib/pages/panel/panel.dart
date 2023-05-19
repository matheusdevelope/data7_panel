import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:data7_panel/components/carousel.dart';
import 'package:data7_panel/models/tableComponentData.dart';
import 'package:data7_panel/models/transform_data.dart';
import 'package:data7_panel/providers/caroussel_model.dart';
import 'package:data7_panel/services/audio.dart';
import 'package:data7_panel/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

import '../../components/bottom_app_bar.dart';
import '../../components/bottom_sheet_menu.dart';
import '../../components/dialog_alert.dart';
import '../../components/loading_animated.dart';

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
  List<CarouselData> dataPanel = [];
  bool opened = false;
  String _message = "";
  late IO.Socket socket;
  late SocketIOClient newSocket = SocketIOClient();

  bool isConnected = true;
  bool isExpanded = false;
  int selectedFontSizeIndex = 2;

  String _legends = '';

  int escPressedCount = 0;

  late CustomDialogAlert Alert;

  final AudioPlayer audioPlayer = AudioPlayer();

  final CarouselController _controller = CarouselController();

  int rowsCountCarousels = 0;
  String currentAudioPath = '';

  void _refreshData(dynamic data) {
    setState(() {
      _lastTimeSync = inputFormat.format(DateTime.now()).toString();
      dataPanel = TransformData().parseData(data.cast<Map<String, dynamic>>());
      setState(() {
        if (dataPanel.isNotEmpty) {
          _legends = dataPanel[0].panels[0].legendColors;
        }
      });
    });
    // _countRows();
  }

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
    newSocket.listen('data_dispath_panel', _refreshData);
  }

  void _reconnect() {
    setState(() {
      _connecting = true;
      _manualAttemptsReconnect++;
    });
    Future.delayed(
      const Duration(seconds: 5),
      () {
        setState(() {
          _connecting = false;
        });
        if (!newSocket.getIsConected()) {
          _openDialogAlert(_manualAttemptsReconnect);
        }
      },
    );
    newSocket.reconnect();
  }

  void _initAlertDialog() {
    Alert = CustomDialogAlert(
      defaultTitle: "Atenção!",
      actions: [
        CustomDialogAction(
          label: "Sair",
          onPress: () {
            _closeDialog();
            Navigator.of(context).pop();
          },
        ),
        CustomDialogAction(label: "Aguardar", onPress: _closeDialog),
        CustomDialogAction(
          label: "Reconectar",
          onPress: () {
            _reconnect();
            _closeDialog();
          },
        ),
      ],
    );
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
    _connected
        ? toggleFontSizeSelector()
        : _openDialogAlert(_manualAttemptsReconnect);
  }

  void _playSound() async {
    try {
      await audioPlayer.stop();
      if (currentAudioPath.isNotEmpty) {
        await audioPlayer.play(DeviceFileSource(currentAudioPath));
      } else {
        await audioPlayer.play(DeviceFileSource(
            await NotificationHelper.getCurrentNotificationAudioPath()));
      }
    } catch (e) {}
  }

  _setNotificationSong() async {
    String tempCurrentAudioPath =
        await NotificationHelper.getCurrentNotificationAudioPath();
    setState(() {
      currentAudioPath = tempCurrentAudioPath;
    });
  }

  @override
  void initState() {
    super.initState();
    _initSocketConnection();
    _initAlertDialog();
    _setNotificationSong();
  }

  @override
  void dispose() {
    newSocket.disconnect();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int qtd = 0;
    for (var data in dataPanel) {
      for (var panel in data.panels) {
        qtd += panel.rows.length;
      }
    }
    if (rowsCountCarousels < qtd) {
      _playSound();
    }
    if (rowsCountCarousels != qtd) {
      setState(() {
        rowsCountCarousels = qtd;
      });
    }

    return ChangeNotifierProvider(
      create: (_) => CarousselModel(),
      child: Scaffold(
        body: dataPanel.isEmpty
            ? LoadingAnimated(
                message: _message,
              )
            : Carousel(
                data: dataPanel,
                controller: _controller,
              ),
        bottomNavigationBar: CustomBottomAppBar(
          legends: _legends,
          lastTimeSync: _lastTimeSync,
          controller: _controller,
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: _onPressFloatingButtom,
          tooltip: _connected ? "Painel Conectado" : "Reconectar",
          backgroundColor: Colors.white,
          child: _connecting
              ? const CircularProgressIndicator()
              : Icon(
                  Icons.connected_tv_outlined,
                  size: 30,
                  color: _connected ? Colors.green : Colors.red,
                ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomSheet: isExpanded ? const BottomSheetMenu() : null,
      ),
    );
  }
}
