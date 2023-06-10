/// Indicates the state of the audio player.
enum PlayerState {
  /// initial state, stop has been called or an error occurred.
  stopped,

  /// Currently playing audio.
  playing,

  /// Pause has been called.
  paused,

  /// The audio successfully completed (reached the end).
  completed,

  /// The player has been disposed and should not be used anymore.
  disposed,
}

class PlayerStateChanged {
  listen(Function(PlayerState) cb) {
    cb(PlayerState.playing);
  }
}

abstract class Source {
  Future<void> setOnPlayer(AudioPlayer player);
}

class DeviceFileSource extends Source {
  final String path;

  DeviceFileSource(this.path);

  @override
  Future<void> setOnPlayer(AudioPlayer player) {
    return player.setSourceDeviceFile(path);
  }

  @override
  String toString() {
    return 'DeviceFileSource(path: $path)';
  }
}

class AudioPlayer {
  PlayerStateChanged onPlayerStateChanged = PlayerStateChanged();
  setSourceDeviceFile(String path) {}
  play(DeviceFileSource path, {double volume = 1}) {
    print('Aqui play');
  }

  resume() {
    print('Aqui resume');
  }

  pause() {
    print('Aqui pause');
  }

  stop() {
    print('Aqui stop');
  }
}
