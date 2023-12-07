import 'package:data7_panel/infra/api/Socket/socket_client.dart';

abstract class ISocket {
  ISocket({required ISocketClientFactory factory});
  List<ISocketClient> clients = [];
  ISocketClient create(SocketParams params);
  void destroy(ISocketClient client);
}
