import 'package:data7_panel/providers/settings_preferences.dart';
import 'package:data7_panel/services/NotificationHelper.dart';
import 'package:file_picker/file_picker.dart';

class Settings {
  static NotificationsSettings notifications = NotificationsSettings();
}

class NotificationsSettings {
  late bool _enabled;
  late String _file;
  late Map<String, String> _files;
  late double _volume;
  late List<String> _filesDefault;
  late NotificationsSettingsPreferences _pref;

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
  }

  set file(String value) {
    _file = value;
    _pref.setFile(value);
  }

  set files(Map<String, String> value) {
    _files = value;
  }

  set volume(double value) {
    _volume = value;
    _pref.setVolume(value);
  }

  deleteFile(String file) async {
    NotificationHelper.deleteNotification(file);
    _files = await NotificationHelper.getObjectListFiles();
  }

  Future<Map<String, String>> addFile(List<String>? pPath) async {
    List<String> pathsToSave = pPath ?? [];
    List<String> retPath = [];
    if (retPath.isEmpty) {
      try {
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(type: FileType.audio, allowMultiple: true);
        if (result != null) {
          for (var path in result.paths) {
            if (path != null) {
              pathsToSave.add(path);
            }
          }
        }
      } catch (e) {}
    }
    for (var path in pathsToSave) {
      retPath.add(await NotificationHelper.saveAudioIntoAppData(path));
    }
    Map<String, String> obj =
        await NotificationHelper.getObjectListFiles(pFiles: retPath);

    return obj;
  }

  _getPreferences() async {
    _enabled = await _pref.getEnabled();
    _file = await _pref.getFile();
    if (_file.isEmpty) {
      _file = (await NotificationHelper.getDefaultNotificationsAudioPath())[0];
      _pref.setFile(_file);
    }
    _files = await NotificationHelper.getObjectListFiles();
    _volume = await _pref.getVolume();

    _filesDefault = await NotificationHelper.getDefaultNotificationsAudioPath();
  }

  Future<NotificationsSettings> initialize() async {
    await _getPreferences();
    return this;
  }
}
