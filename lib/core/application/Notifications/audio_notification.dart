import 'package:data7_panel/core/infra/services/Interfaces/audio_player.dart';
import 'package:data7_panel/core/infra/services/Models/audio.dart';

class AudioNotification {
  IAudioPlayer player;
  AudioNotification({required this.player});

  Future<void> play(Audio audio) async {
    return await player.play(audio: audio);
  }
}
