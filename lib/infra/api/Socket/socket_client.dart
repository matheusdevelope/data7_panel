typedef SocketListenerCallback = void Function(dynamic data);

class SocketState {
  bool connected = false;
  bool disconnected = false;
  bool reconnecting = false;
  bool reconnectingError = false;
  int attemptsReconnect = 0;
}

class SocketParams {
  final String url;
  final Map<String, dynamic>? queryParams;
  final int reconnectAttemptsDelay;
  final int maxReconnectAttempts;
  final Function(bool)? onConnectionChange;
  final Function(int)? onReconnectionAttempt;
  final Function(dynamic)? onConnectionError;
  final Function(int)? onMaxReconnectAttemptsReached;
  final Function()? onReconnected;

  SocketParams({
    required this.url,
    this.queryParams,
    this.reconnectAttemptsDelay = 1000,
    this.maxReconnectAttempts = 10,
    this.onConnectionChange,
    this.onReconnectionAttempt,
    this.onConnectionError,
    this.onMaxReconnectAttemptsReached,
    this.onReconnected,
  });
}

abstract class ISocketClient {
  ISocketClient({required SocketParams params});
  bool get connected;

  void connect();
  void disconnect();
  void reconnect();
  void on(String eventName, SocketListenerCallback callback);
  void off(String eventName, SocketListenerCallback callback);
  void removeAllListeners();
}

abstract class ISocketClientFactory {
  ISocketClient create(SocketParams params);
}
