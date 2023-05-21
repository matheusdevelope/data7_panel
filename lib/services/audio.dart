import 'package:audioplayers/audioplayers.dart';
import 'package:data7_panel/custom_theme.dart';

class AudioHelper {
  static final AudioHelper _instance = AudioHelper._internal();
  factory AudioHelper() {
    return _instance;
  }
  AudioHelper._internal();

  bool initializeded = false;
  bool isPlaying = false;
  bool isPaused = false;
  String currentFile = '';

  late AudioPlayer audioPlayer;
  initialize() {
    if (!initializeded) {
      initializeded = true;
      audioPlayer = AudioPlayer();
      audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.stopped) {
          isPlaying = false;
          isPaused = false;
        }
        if (state == PlayerState.paused) {
          isPaused = true;
          isPlaying = false;
        }
        if (state == PlayerState.playing) {
          isPlaying = true;
          isPaused = false;
        }
      });
    }
    return this;
  }

  playPause(String path, {bool stopAll = true, double volume = 1}) {
    if (isPlaying && path == currentFile) return pause();
    return play(path, volume: volume, stopAll: stopAll);
  }

  play(String path, {bool stopAll = true, double volume = 1}) {
    initialize();
    if (stopAll && isPlaying) audioPlayer.stop();
    currentFile = path;
    isPlaying = true;
    audioPlayer.play(DeviceFileSource(path), volume: volume);
  }

  resume() {
    initialize();
    if (isPaused) audioPlayer.resume();
  }

  pause() {
    initialize();
    audioPlayer.pause();
  }

  stop() {
    initialize();
    audioPlayer.stop();
  }
}
