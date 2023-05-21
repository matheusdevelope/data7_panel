import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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

  static Future<List<String>> getDefaultNotificationsAudioPath() async {
    String currentAudioPath = '';
    String filename = 'notification.mp3';
    ByteData bytes = await rootBundle.load("assets/songs/$filename");
    currentAudioPath =
        await NotificationHelper.saveAudioDefaultAssetsIntoAppData(
            bytes, filename);
    return [currentAudioPath];
  }

  static Future<String> saveAudioDefaultAssetsIntoAppData(
      ByteData bytes, String filename) async {
    String path = '${await NotificationHelper.getNotificationsDir()}$filename';
    File file = File(path);
    if (file.existsSync()) return file.path;

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

  static Future<Map<String, String>> getObjectListFiles(
      {List<String>? pFiles}) async {
    List<String> files = [];
    if (pFiles != null && pFiles.isNotEmpty) {
      files = pFiles;
    } else {
      files = await NotificationHelper.loadAvailableNotifications();
      if (files.isEmpty) await getDefaultNotificationsAudioPath();
      files = await NotificationHelper.loadAvailableNotifications();
    }
    Map<String, String> obj = {};
    for (var file in files) {
      String name = p.basenameWithoutExtension(file);
      obj[file] = name.toLowerCase().replaceFirst(
          name.substring(0, 1), name.substring(0, 1).toUpperCase());
    }
    return obj;
  }

  static deleteNotification(String path) {
    File(path).delete();
  }
}
