import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late IO.Socket socket;
  _connectSocket() {
    socket = IO.io(
        'http://26.120.212.43:3546',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.onConnect((_) {
      print('connect');
      // socket.emit('msg', 'test');
    });
    socket.on('data_dispath_panel', (data) => listOfColumns = data);
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
    socket.connect();
  }

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text('Number'),
            ),
          ],
          rows: List<DataRow>.generate(
              listOfColumns.length,
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
                    cells: <DataCell>[DataCell(Text('Row $i'))],
                  ))),
    );
  }
}
