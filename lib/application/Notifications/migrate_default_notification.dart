import 'package:data7_panel/infra/services/Interfaces/audio_manager.dart';
import 'package:flutter/services.dart';

class MigrateDefaultNotification {
  IAudioManager audioManager;
  MigrateDefaultNotification({required this.audioManager});
  Future<bool> execute() async {
    String filename = 'notification.mp3';
    if (await audioManager.exists(filename)) return true;
    ByteData data = await rootBundle.load("assets/songs/$filename");
    await audioManager.saveBytes(filename: filename, data: data);
    return true;
  }
}
