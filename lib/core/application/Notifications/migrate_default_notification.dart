import 'package:data7_panel/core/infra/services/Interfaces/audio_manager.dart';
import 'package:flutter/services.dart';

class MigrateDefaultNotification {
  static Future<bool> execute(IAudioManager audioManager) async {
    String filename = 'notification.mp3';
    if (await audioManager.exists(filename)) return true;
    ByteData data = await rootBundle.load("assets/songs/$filename");
    await audioManager.saveBytes(filename: filename, data: data);
    return true;
  }
}
