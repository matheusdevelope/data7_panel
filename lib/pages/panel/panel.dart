import 'package:data7_panel/models/tableComponentData.dart';
import 'package:data7_panel/pages/panel/transform_data.dart';
import 'package:data7_panel/providers/theme_model.dart';
import 'package:data7_panel/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';
import 'dart:math' as math;

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

  FocusNode _focusNode = FocusNode();
  late FocusAttachment _focusAttachment;

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

  void _openDialogAlert(int attempts) {
    if (_isOpenDialog) return;

    newSocket.onReconnectedCallback = _closeDialog;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção!'),
          content: Text(
            "Painel Desconectado.\nVerifique se o servidor está ativo e disponível no endereço fornececido.\nTentativas de conexão: ${attempts}",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Sair"),
              onPressed: () {
                _closeDialog();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Aguardar"),
              onPressed: () {
                _closeDialog();
              },
            ),
            ElevatedButton(
              autofocus: true,
              onPressed: () {
                _reconnect();
                _closeDialog();
              },
              child: const Text("Reconectar"),
            ),
          ],
        );
      },
    );
    _isOpenDialog = true;
  }

  void _closeDialog() {
    newSocket.onReconnectedCallback = null;
    Navigator.of(context, rootNavigator: true).pop('dialog');
    setState(() {
      _isOpenDialog = false;
    });
  }

  void toggleFontSizeSelector() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  int _esc_pressed_count = 0;

  @override
  void initState() {
    super.initState();
    _initSocketConnection();
    _focusAttachment = _focusNode.attach(context, onKeyEvent: (node, event) {
      setState(() {
        _esc_pressed_count++;
      });
      if (event.logicalKey.keyId == LogicalKeyboardKey.escape.keyId &&
          _esc_pressed_count == 1) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      return KeyEventResult.handled;
    });
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    newSocket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const minFont = 10.0;
    const maxFont = 60.0;
    buildListLegends(
        List<String> legends, BuildContext context, double fontSize) {
      return Wrap(
          children: List<Row>.generate(
              legends.length,
              (index) => Row(mainAxisSize: MainAxisSize.min, children: [
                    if (legends[index].toString().contains(":"))
                      Icon(Icons.circle,
                          color: Color(int.parse(legends[index]
                              .split(":")[0]
                              .replaceAll("#", "0xFF")))),
                    if (legends[index].toString().contains(':'))
                      Text(legends[index].split(":")[1].toString(),
                          style: TextStyle(fontSize: fontSize)),
                    const SizedBox(
                      width: 4.0,
                    )
                  ])));
    }

    _focusAttachment.reparent();
    return
        // RawKeyboardListener(
        //     focusNode: FocusNode(),
        //     onKey: (RawKeyEvent event) {
        //       print(event.logicalKey);
        //       if (event.logicalKey == LogicalKeyboardKey.escape) {
        //         // Handle the ESC key press event
        //         Navigator.of(context).pop();
        //       }
        //     },
        //     child:
        Consumer<ThemeModel>(builder: (context, ThemeModel theme, child) {
      return Scaffold(
          body: dataPanel.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Lottie.asset(
                          'assets/loading.json',
                        ),
                      ),
                      if (_message.isNotEmpty)
                        Container(
                            padding: const EdgeInsets.only(
                                top: 10, right: 16, bottom: 30, left: 16),
                            child: Text(_message))
                    ],
                  ),
                )
              : RenderPanels(
                  dataList: dataPanel, isHorizontal: dataPanel[0].isHorizontal),
          bottomNavigationBar: BottomAppBar(
              padding: const EdgeInsets.only(top: 8),
              shape: const CircularNotchedRectangle(),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  // runAlignment: WrapAlignment.spaceBetween,
                  // alignment: WrapAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: buildListLegends(_legends.split(','), context,
                            theme.fontSizeMenuPanel)),
                    Expanded(
                        flex: 1,
                        child: Text(
                          _lastTimeSync,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: theme.fontSizeMenuPanel),
                        )),
                  ],
                ),
              )
              //)
              ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _connected ? toggleFontSizeSelector() : _reconnect();
            },
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
          bottomSheet: isExpanded
              ? Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  alignment: WrapAlignment.center,
                  children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform.rotate(
                              angle: 180 * math.pi / 180,
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                iconSize: theme.fontSizeMenuPanel + 8.0,
                                tooltip: 'Voltar',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.exit_to_app_outlined,
                                  color: Colors.red,
                                ),
                              ))
                        ],
                      ),
                      const Divider(),
                      SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                "Fonte Geral:",
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Slider(
                                  value: theme.fontSize,
                                  min: minFont,
                                  max: maxFont,
                                  divisions: (maxFont - minFont).toInt(),
                                  onChanged: (value) {
                                    theme.fontSize = value;
                                    theme.fontSizeTitlePanel = value;
                                    theme.fontSizeDataPanel = value;
                                    theme.fontSizeMenuPanel = value;
                                  }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                "Titulo Painel:",
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Slider(
                                  value: theme.fontSizeTitlePanel,
                                  min: minFont,
                                  max: maxFont,
                                  divisions: (maxFont - minFont).toInt(),
                                  onChanged: (value) {
                                    theme.fontSizeTitlePanel = value;
                                  }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                "Linhas Painel:",
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Slider(
                                  value: theme.fontSizeDataPanel,
                                  min: minFont,
                                  max: maxFont,
                                  divisions: (maxFont - minFont).toInt(),
                                  onChanged: (value) {
                                    theme.fontSizeDataPanel = value;
                                  }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                "Menu Painel:",
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Slider(
                                  value: theme.fontSizeMenuPanel,
                                  min: minFont,
                                  max: maxFont,
                                  divisions: (maxFont - minFont).toInt(),
                                  onChanged: (value) {
                                    theme.fontSizeMenuPanel = value;
                                  }),
                            )
                          ],
                        ),
                      ),
                    ])
              : null);
    });
  }
}
