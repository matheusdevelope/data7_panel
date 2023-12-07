import 'package:data7_panel/infra/api/Socket/socket.dart';
import 'package:data7_panel/infra/api/Socket/socket_client.dart';

class Socket implements ISocket {
  final ISocketClientFactory socketClientFactory;
  Socket({required this.socketClientFactory});
  @override
  List<ISocketClient> clients = [];

  @override
  ISocketClient create(SocketParams params) {
    final client = socketClientFactory.create(params);
    clients.add(client);
    return client;
  }

  @override
  void destroy(ISocketClient client) {
    client.disconnect();
    client.removeAllListeners();
    clients.remove(client);
  }
}
