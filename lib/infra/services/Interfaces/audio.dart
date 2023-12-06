import 'package:data7_panel/infra/services/Models/audio.dart';

abstract class IAudio {
  bool get isPlaying;
  Audio? get currentAudio;
  Future<void> play(Audio audio);
  Future<void> pause();
  Future<void> stop();
  Future<void> resume();
  Future<void> playPause(Audio audio);
  Future<void> resumePause(Audio audio);
}
