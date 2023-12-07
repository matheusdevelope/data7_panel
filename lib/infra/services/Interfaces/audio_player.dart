import 'package:data7_panel/infra/services/Models/audio.dart';

abstract class IAudioPlayer {
  bool get isPlaying;
  Audio? get currentAudio;
  Future<void> play({required Audio audio, double? volume, bool? stopAll});
  Future<void> pause();
  Future<void> stop();
  Future<void> resume();
  Future<void> playPause(Audio audio);
  Future<void> resumePause(Audio audio);
  Future<void> setVolume(double volume);
}
