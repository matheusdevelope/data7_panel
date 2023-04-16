import 'package:data7_panel/components/dialogAlert.dart';
import 'package:data7_panel/models/tableComponentData.dart';
import 'package:data7_panel/pages/panel/table.dart';
import 'package:data7_panel/pages/panel/transform_data.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

import '../../../components/BottomPanelBar.dart';

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
  TableComponentData dataPanel = TableComponentData(columns: [], rows: []);
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

  @override
  void initState() {
    _connectSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (dataPanel.columns.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Conectando ao servidor... \n ${_connecting.toString()} \n Error:${_error.toString()}',
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

    // return Scaffold(
    //   body: LayoutBuilder(
    //     builder: (contextH, constraintsH) => SingleChildScrollView(
    //       scrollDirection: Axis.horizontal,
    //       child: Column(
    //         children: [
    //           Column(
    //             children: [
    //               const Text('My Text'),
    //               Container(
    //                   alignment: Alignment.topLeft,
    //                   child: LayoutBuilder(
    //                     builder: (contextY, constraints) =>
    //                         SingleChildScrollView(
    //                       child: ConstrainedBox(
    //                         constraints:
    //                             BoxConstraints(minWidth: constraints.minWidth),
    //                         child: TableComponent(
    //                           data: dataPanel,
    //                         ),
    //                       ),
    //                     ),
    //                   )),
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                  child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                              constraints: BoxConstraints.expand(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height),
                              child: TableComponent(
                                data: dataPanel,
                              ))))),
              Expanded(
                  child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                              constraints: BoxConstraints.expand(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height),
                              child: TableComponent(
                                data: dataPanel,
                              )))))
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomPanelBar(
          connected: _connected,
          legends: "#FF0000:1h, #FFFF00:0h30m, #00FF00:0h15m",
          lastTimeSync: _lastTimeSync,
          fontSize: dataPanel.fontSize,
          callback: () {
            showAlertDialog(context, "Atenção",
                "Painel Desconectado.\nVerifique se o servidor está ativo e disponível no endereço fornececido.",
                closeButton: "Fechar",
                actionButton: "Tentar Reconectar", callback: () {
              _connectSocket();
            });
          }),
    );
  }
}
