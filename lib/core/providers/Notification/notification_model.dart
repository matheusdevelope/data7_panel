import 'package:data7_panel/core/infra/services/Interfaces/audio_manager.dart';
import 'package:data7_panel/core/providers/Notification/notification_preferences.dart';
import 'package:data7_panel/core/providers/Settings/settings_preferences.dart';
import 'package:data7_panel/dependecy_injection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NotificationsSettings extends ChangeNotifier {
  final audioManager = DI.get<IAudioManager>();
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

  Future<Map<String, String>> add({List<String>? filesPath}) async {
    List<String> pathsToSave = filesPath ?? [];
    if (pathsToSave.isEmpty) {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.audio, allowMultiple: true);
      if (result != null) {
        for (var path in result.paths) {
          if (path != null) {
            pathsToSave.add(path);
          }
        }
      }
    }
    for (var path in pathsToSave) {
      await audioManager.save(path);
    }
    return _setFiles();
  }

  delete(String path) async {
    await audioManager.delete(path);
    _setFiles();
  }

  _setFiles() async {
    final audioManager = DI.get<IAudioManager>();
    final audiosList = await audioManager.list();
    Map<String, String> newObj = {};
    for (var audio in audiosList) {
      newObj[audio.path] = audio.name;
    }
    files = newObj;
    return newObj;
  }

  _getPreferences() async {
    _enabled = await _pref.getEnabled();
    _volume = await _pref.getVolume();
    _file = await _pref.getFile();
    if (_file.isEmpty) {
      _pref.setFile(_file);
    }
    _setFiles();
    // _filesDefault = await NotificationHelper.getDefaultNotificationsAudioPath();
  }

  Future<NotificationsSettings> initialize() async {
    await _getPreferences();
    return this;
  }
}
