import 'package:data7_panel/components/bottom_bar2.dart';
import 'package:data7_panel/components/bottom_bar_panel.dart';
import 'package:data7_panel/components/dialogAlert.dart';
import 'package:data7_panel/components/font_size_selector.dart';
import 'package:data7_panel/models/tableComponentData.dart';
import 'package:data7_panel/pages/panel/transform_data.dart';
import 'package:data7_panel/providers/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

import '../../components/BottomPanelBar.dart';
import 'render_panel.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key, required this.url});
  final String url;
  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  bool _connected = false;
  String _lastTimeSync = '';
  List<TableComponentData> dataPanel = [];
  bool _connecting = false;
  String _error = "";
  late IO.Socket socket;
  _connectSocket() {
    socket = IO.io(
        widget.url,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.onConnect((_) {
      setState(() {
        _connected = true;
      });
    });
    socket.on('data_dispath_panel', (data) {
      setState(() {
        _lastTimeSync = inputFormat.format(DateTime.now()).toString();
        dataPanel =
            TransformData().parseData(data.cast<Map<String, dynamic>>());
      });
    });
    socket.onDisconnect((_) {
      setState(() {
        _connected = false;
      });
      showAlertDialog(context, "Atenção",
          "Painel Desconectado.\nVerifique se o servidor está ativo e disponível no endereço fornececido.",
          closeButton: "Fechar",
          actionButton: "Tentar Reconectar", callback: () {
        _connectSocket();
      });
    });
    socket.onConnecting((data) {
      setState(() {
        _connecting = true;
      });
    });
    socket.onConnectError((data) {
      setState(() {
        _error = data.toString();
      });
    });
    socket.connect();
  }

  bool isConnected = true;
  bool isExpanded = false;
  int selectedFontSizeIndex = 2;
  final List<double> fontSizes = [16, 18, 20, 22];

  void toggleConnection() {
    setState(() {
      isConnected = !isConnected;
    });
  }

  void toggleFontSizeSelector() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void setSelectedFontSizeIndex(int index) {
    setState(() {
      selectedFontSizeIndex = index;
      isExpanded = false;
    });
  }

  @override
  void initState() {
    _connectSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final minFont = 10.0;
    final maxFont = 60.0;

    if (dataPanel.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Conectando ao servidor... \n ${_connecting.toString()} ${_error.toString().isNotEmpty ? _error.toString() : ""}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              const CircularProgressIndicator()
            ],
          ),
        ),
      );
    }

    return Consumer<ThemeModel>(builder: (context, ThemeModel theme, child) {
      return Scaffold(
        body: RenderPanels(dataList: dataPanel, isHorizontal: false),
        bottomNavigationBar: MyBottomAppBar(
          isConnected: _connected,
          onConnectionButtonPressed: toggleConnection,
          lastSyncTime: _lastTimeSync,
          legends: dataPanel[0].legendColors,
          isExpanded: isExpanded,
          onExpandButtonPressed: toggleFontSizeSelector,
          selectedFontSizeIndex: selectedFontSizeIndex,
          fontSizes: fontSizes,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _connected ? toggleFontSizeSelector() : _connectSocket();
          },
          tooltip: _connected ? "Painel Conectado" : "Reconectar",
          backgroundColor: Colors.white,
          child: Icon(
            Icons.connected_tv_outlined,
            size: theme.fontSizeMenuPanel + 10,
            color: _connected ? Colors.green : Colors.red,
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomSheet: isExpanded
            ? FontSizeSelector(
                fontSize: theme.fontSizeMenuPanel,
                selectorDataList: [
                  FontSizeSelectorData(
                    label: 'Geral:',
                    value: theme.fontSize,
                    minValue: minFont,
                    maxValue: maxFont,
                    onChangeValue: (value) => (value) {
                      print(value);
                      theme.fontSize = value;
                    },
                  ),
                  FontSizeSelectorData(
                    label: 'Titulo do Painel:',
                    value: theme.fontSizeTitlePanel,
                    minValue: minFont,
                    maxValue: maxFont,
                    onChangeValue: (value) => (value) {
                      theme.fontSizeTitlePanel = value;
                    },
                  ),
                  FontSizeSelectorData(
                    label: 'Linhas do Painel:',
                    value: theme.fontSizeDataPanel,
                    minValue: minFont,
                    maxValue: maxFont,
                    onChangeValue: (value) => (value) {
                      theme.fontSizeDataPanel = value;
                    },
                  ),
                  FontSizeSelectorData(
                    label: 'Menu do Painel:',
                    value: theme.fontSizeMenuPanel,
                    minValue: minFont,
                    maxValue: maxFont,
                    onChangeValue: (value) {
                      theme.fontSizeMenuPanel = value;
                    },
                  ),
                ],
              )
            : null,

        // CustomBottomNavigationBar(    isConnected: _connected, updateTime: _lastTimeSync, dynamicIcons: [])

        // BottomPanelBar(
        //     connected: _connected,
        //     legends: dataPanel[0].legendColors,
        //     lastTimeSync: _lastTimeSync,
        //     callback: () {
        //       showAlertDialog(context, "Atenção",
        //           "Painel Desconectado.\nVerifique se o servidor está ativo e disponível no endereço fornececido.",
        //           closeButton: "Fechar",
        //           actionButton: "Tentar Reconectar", callback: () {
        //         _connectSocket();
        //       });
        //     }),
      );
    });
  }
}
