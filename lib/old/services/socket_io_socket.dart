import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIOClient {
  static final SocketIOClient _instance = SocketIOClient._internal();

  factory SocketIOClient() {
    return _instance;
  }

  SocketIOClient._internal();

  IO.Socket? _socket;
  bool isConnected = false;
  bool callDisconect = false;
  bool _calledAttemptsCallback = false;
  late String _url;
  late int _reconnectAttemptsDelay;
  late int _maxReconnectAttempts;
  int _attempts = 0;
  Function(bool)? onConnectionChangeCallback;
  Function(int)? onReconnectionAttemptCallback;
  Function(dynamic)? onConnectionErrorCallback;
  Function(int)? onMaxReconnectAttemptsReachedCallback;
  Function? onReconnectedCallback;

  void connect({
    required String url,
    int reconnectAttemptsDelay = 1000,
    int maxReconnectAttempts = 10,
    Function(bool)? onConnectionChange,
    Function(int)? onReconnectionAttempt,
    Function(dynamic)? onConnectionError,
    Function(int)? onMaxReconnectAttemptsReached,
    Function()? onReconnected,
  }) {
    _url = url;
    _reconnectAttemptsDelay = reconnectAttemptsDelay;
    _maxReconnectAttempts = maxReconnectAttempts;
    onConnectionChangeCallback = onConnectionChange;
    onReconnectionAttemptCallback = onReconnectionAttempt;
    onConnectionErrorCallback = onConnectionError;
    onMaxReconnectAttemptsReachedCallback = onMaxReconnectAttemptsReached;
    onReconnectedCallback = onReconnected;
    _connect();
  }

  setCancelReconnectCallback() {
    _calledAttemptsCallback = false;
  }

  getIsConected() {
    return isConnected;
  }

  void _connect() {
    _socket = IO.io(
        _url,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setReconnectionDelay(_reconnectAttemptsDelay)
            .build());

    _socket!.on('connect', (_) {
      isConnected = true;
      callDisconect = false;
      _onConnectionChange(isConnected);
      _attempts = 0;
    });

    _socket!.on('disconnect', (message) {
      isConnected = false;
      if (message.toString().toLowerCase().trim() != 'io client disconnect') {
        _onConnectionChange(isConnected);
        _attemptReconnect();
      }
    });

    _socket!.on('reconnect', (_) {
      isConnected = true;
      _onConnectionChange(isConnected);
      _attempts = 0;
    });
    _socket!.on('connect_error', (error) {
      isConnected = false;
      _onConnectionError(error);
    });

    _socket!.connect();
  }

  void _attemptReconnect() {
    if (!isConnected) {
      if (_attempts < _maxReconnectAttempts) {
        _attempts++;
        _onReconnectionAttempt(_attempts);
        Future.delayed(Duration(milliseconds: _reconnectAttemptsDelay))
            .then((_) {
          reconnect();
          if (!isConnected) {
            _attemptReconnect();
          }
        });
      } else {
        onMaxReconnectAttemptsReachedCallback!(_attempts);
        _calledAttemptsCallback = true;
      }
    }
  }

  void reconnect() {
    if (_socket != null) {
      _socket!.connect();
    } else {
      _connect();
    }
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.dispose();
      _socket = null;
      isConnected = false;
      callDisconect = true;
    }
  }

  void _onConnectionChange(bool isConnected) {
    if (onConnectionChangeCallback != null) {
      onConnectionChangeCallback!(isConnected);
    }
    if (_calledAttemptsCallback && onReconnectedCallback != null) {
      onReconnectedCallback!();
    }
    if (isConnected) {
      _calledAttemptsCallback = false;
    }
  }

  void _onReconnectionAttempt(int attempts) {
    if (onReconnectionAttemptCallback != null) {
      onReconnectionAttemptCallback!(attempts);
    }
  }

  void _onConnectionError(dynamic data) {
    if (onConnectionErrorCallback != null) {
      onConnectionErrorCallback!(data);
    }
  }

  void listen(String eventName, callback) {
    if (_socket != null) {
      _socket!.on(eventName, callback);
    }
  }

  String generateRandomId() {
    const String characters =
        "ABCDEFGHI-JKLMNOPQRSTUV-WXYZabc-efghij-klmnopq-rstuvwxy-z0123456789";
    const int charactersLength = characters.length;
    String id = '';
    for (int i = 0; i < 20; i++) {
      id +=
          characters[DateTime.now().microsecondsSinceEpoch % charactersLength];
    }
    return id;
  }
}
