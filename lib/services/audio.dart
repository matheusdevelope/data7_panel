import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class NotificationHelper {
  static String notificationDefault = 'notification.mp3';

  // static loadFilesFromAssetsToLocalResources(BuildContext context) async {
  //   var assetsFile =
  //       await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
  //   final Map<String, dynamic> manifestMap = json.decode(assetsFile);
  //   // print(manifestMap);
  // }

  static Future<String> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await Directory(p.dirname(path)).create(recursive: true);
    File file = await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return file.path;
  }

  static Future<String> getCurrentNotificationAudioPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentAudioPath = prefs.getString('current_notification') ?? '';
    if (currentAudioPath.isEmpty) {
      String filename = 'notification.mp3';
      ByteData bytes = await rootBundle.load("assets/songs/notification.mp3");
      currentAudioPath =
          await NotificationHelper.saveAudioDefaultAssetsIntoAppData(
              bytes, filename);
    }
    return currentAudioPath;
  }

  static Future<String> saveAudioDefaultAssetsIntoAppData(
      ByteData bytes, String filename) async {
    String path = '${await NotificationHelper.getNotificationsDir()}$filename';
    return NotificationHelper.writeToFile(bytes, path);
  }

  static Future<String> saveAudioIntoAppData(String path) async {
    File file = File(path);
    String filePath =
        await NotificationHelper.getNotificationsDir() + p.basename(path);
    file.copySync(filePath);
    return filePath;
  }

  static Future<String> getNotificationsDir() async {
    return '${(await getApplicationSupportDirectory()).path}/songs/';
  }

  static Future<List<String>> loadAvailableNotifications() async {
    List<FileSystemEntity> list =
        Directory(await NotificationHelper.getNotificationsDir())
            .listSync(recursive: true, followLinks: false);
    return list.map((e) => e.path).toList();
  }
}
