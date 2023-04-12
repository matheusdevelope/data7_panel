import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key, required this.url});
  final String url;
  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  bool _connected = false;
  String _lastTimeSync = '';
  List<dynamic> _data = [];
  List<String> _columnTitles = [];

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
        _data = json.decode(data);
        _columnTitles = _data[0].keys.toList();
      });
    });
    socket.onDisconnect((_) {
      setState(() {
        _connected = false;
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
    if (_columnTitles.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.url),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Aguardando Itens',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {
                  socket.disconnect();
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.url),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: DataTable(
                  sortColumnIndex: 0,
                  sortAscending: true,
                  columns:
                      List<DataColumn>.generate(_columnTitles.length, (index) {
                    return DataColumn(
                        label: Text(_columnTitles[index].substring(
                            _columnTitles[index].indexOf("_") + 1,
                            _columnTitles[index].length)));
                  }),
                  rows: List<DataRow>.generate(
                      _data.length,
                      (int i) => DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              // All rows will have the same selected color.
                              if (states.contains(MaterialState.selected)) {
                                return Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.08);
                              }
                              // Even rows will have a grey color.
                              if (i.isEven) {
                                return Colors.grey.withOpacity(0.3);
                              }
                              return null; // Use default value for other states and odd rows.
                            }),
                            cells: List<DataCell>.generate(_columnTitles.length,
                                (index) {
                              return DataCell(Text(
                                  _data[i][_columnTitles[index]].toString()));
                            }),
                          ))),
            ),
            Text(
              'Última Atualização: $_lastTimeSync',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
              onPressed: () {
                socket.disconnect();
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
