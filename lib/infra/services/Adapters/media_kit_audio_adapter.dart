import 'package:data7_panel/infra/services/Interfaces/audio.dart';
import 'package:data7_panel/infra/services/Models/audio.dart';
import 'package:media_kit/media_kit.dart';

class MediaKitAudioAdapter implements IAudio {
  final Player _player = Player();
  Audio? _currentAudio;
  MediaKitAudioAdapter();

  @override
  get isPlaying => _player.state.playing;

  @override
  Audio? get currentAudio => _currentAudio;

  @override
  play(Audio audio) async {
    _player.setVolume(audio.volume);
    _currentAudio = audio;
    if (audio.stopAll) {
      await _player.stop();
    }
    if (_currentAudio?.path == audio.path) {
      await _player.play();
      return;
    }
    await _player.open(Media(audio.path), play: true);
  }

  @override
  pause() async {
    await _player.pause();
  }

  @override
  playPause(Audio audio) async {
    isPlaying ? await pause() : await play(audio);
  }

  @override
  resumePause(Audio audio) async {
    isPlaying ? await pause() : await play(audio);
  }

  @override
  resume() async {
    await _player.play();
  }

  @override
  stop() async {
    await _player.stop();
    _currentAudio = null;
  }
}
