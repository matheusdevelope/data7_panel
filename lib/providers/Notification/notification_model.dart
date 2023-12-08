import 'package:data7_panel/providers/Notification/notification_preferences.dart';
import 'package:data7_panel/providers/Settings/settings_preferences.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NotificationsSettings extends ChangeNotifier {
  late bool _enabled;
  late String _file;
  late Map<String, String> _files;
  late double _volume;
  late List<String> _filesDefault;
  late NotificationPreferences _pref;

  bool get enabled => _enabled;
  String get file => _file;
  double get volume => _volume;
  List<String> get filesDefault => _filesDefault;
  Map<String, String> get files => _files;
  NotificationsSettings() {
    _enabled = true;
    _file = "";
    _files = {};
    _filesDefault = ["notification.mp3"];
    _pref = SettingsPreferences.notifications;
    _getPreferences();
  }
  set enabled(bool value) {
    _enabled = value;
    _pref.setEnabled(value);
    notifyListeners();
  }

  set file(String value) {
    _file = value;
    _pref.setFile(value);
    notifyListeners();
  }

  set files(Map<String, String> value) {
    _files = value;
    notifyListeners();
  }

  set volume(double value) {
    _volume = value;
    _pref.setVolume(value);
    notifyListeners();
  }

  // deleteFile(String file) async {
  //   NotificationHelper.deleteNotification(file);
  //   _files = await NotificationHelper.getObjectListFiles();
  //   notifyListeners();
  // }

  // Future<Map<String, String>> addFile(List<String>? pPath) async {
  //   List<String> pathsToSave = pPath ?? [];
  //   List<String> retPath = [];
  //   if (retPath.isEmpty) {
  //     try {
  //       FilePickerResult? result = await FilePicker.platform
  //           .pickFiles(type: FileType.audio, allowMultiple: true);
  //       if (result != null) {
  //         for (var path in result.paths) {
  //           if (path != null) {
  //             pathsToSave.add(path);
  //           }
  //         }
  //       }
  //     } catch (e) {}
  //   }
  //   for (var path in pathsToSave) {
  //     retPath.add(await NotificationHelper.saveAudioIntoAppData(path));
  //   }
  //   Map<String, String> obj =
  //       await NotificationHelper.getObjectListFiles(pFiles: retPath);

  //   notifyListeners();
  //   return obj;
  // }

  _getPreferences() async {
    _enabled = await _pref.getEnabled();
    _file = await _pref.getFile();
    if (_file.isEmpty) {
      // _file = (await NotificationHelper.getDefaultNotificationsAudioPath())[0];
      _pref.setFile(_file);
    }
    // _files = await NotificationHelper.getObjectListFiles();
    _volume = await _pref.getVolume();

    // _filesDefault = await NotificationHelper.getDefaultNotificationsAudioPath();
  }

  Future<NotificationsSettings> initialize() async {
    await _getPreferences();
    return this;
  }
}
