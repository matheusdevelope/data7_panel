import 'package:data7_panel/infra/api/Socket/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketIOClientFactory implements ISocketClientFactory {
  @override
  ISocketClient create(SocketParams params) {
    return SocketIOClient(params: params);
  }
}

class SocketIOClient implements ISocketClient {
  late Socket _socket;
  final SocketParams params;
  bool _connected = false;
  bool _calledAttemptsCallback = false;
  int _attempts = 0;

  SocketIOClient({required this.params}) {
    _socket = io(
      params.url,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setReconnectionDelay(params.reconnectAttemptsDelay)
          .build(),
    );
  }

  @override
  bool get connected => _connected;

  @override
  void connect() {
    _socket.on('connect', (_) {
      _connected = true;
      _onConnectionChange(_connected);
      _attempts = 0;
    });

    _socket.on('disconnect', (message) {
      _connected = false;
      if (message.toString().toLowerCase().trim() != 'io client disconnect') {
        _onConnectionChange(_connected);
        _attemptReconnect();
      }
    });

    _socket.on('reconnect', (_) {
      _connected = true;
      _onConnectionChange(_connected);
      _attempts = 0;
    });

    _socket.on('connect_error', (error) {
      _connected = false;
      _onConnectionError(error);
    });

    _socket.connect();
  }

  @override
  void reconnect() {
    if (_socket.connected) {
      _socket.disconnect();
    }
    _socket.connect();
  }

  @override
  void disconnect() {
    _socket.disconnect();
    _connected = false;
  }

  @override
  void on(String eventName, SocketListenerCallback callback) {
    _socket.on(eventName, callback);
  }

  @override
  void off(String eventName, SocketListenerCallback callback) {
    _socket.off(eventName, callback);
  }

  @override
  void removeAllListeners() {
    _socket.clearListeners();
  }

  void _attemptReconnect() {
    if (!_connected) {
      if (_attempts < params.maxReconnectAttempts) {
        _attempts++;
        _onReconnectionAttempt(_attempts);
        Future.delayed(Duration(milliseconds: params.reconnectAttemptsDelay))
            .then((_) {
          reconnect();
          if (!_connected) {
            _attemptReconnect();
          }
        });
      } else {
        params.onMaxReconnectAttemptsReached!(_attempts);
        _calledAttemptsCallback = true;
      }
    }
  }

  void _onConnectionChange(bool connected) {
    if (params.onConnectionChange != null) {
      params.onConnectionChange!(connected);
    }
    if (_calledAttemptsCallback && params.onReconnected != null) {
      params.onReconnected!();
    }
    if (connected) {
      _calledAttemptsCallback = false;
    }
  }

  void _onReconnectionAttempt(int attempts) {
    if (params.onReconnectionAttempt != null) {
      params.onReconnectionAttempt!(attempts);
    }
  }

  void _onConnectionError(dynamic data) {
    if (params.onConnectionError != null) {
      params.onConnectionError!(data);
    }
  }
}
