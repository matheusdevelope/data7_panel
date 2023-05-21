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

class DatabaseConnectionSettings {
  late String _rdbms;
  late String _user;
  late String _pass;
  late String _server;
  late String _port;
  late String _databaseName;

  late DatabaseConnectionPreferences _pref;

  String get rdbms => _rdbms;
  String get user => _user;
  String get pass => _pass;
  String get server => _server;
  String get port => _port;
  String get databaseName => _databaseName;
  DatabaseConnectionSettings() {
    _rdbms = '';
    _user = '';
    _pass = '';
    _server = '';
    _port = '';
    _databaseName = '';
    _pref = SettingsPreferences.database;
    _getPreferences();
  }

  set rdbms(String value) {
    _rdbms = value;
    _pref.setRdbms(value);
  }

  set user(String value) {
    _user = value;
    _pref.setUser(value);
  }

  set pass(String value) {
    _pass = value;
    _pref.setPass(value);
  }

  set server(String value) {
    _server = value;
    _pref.setServer(value);
  }

  set port(String value) {
    _port = value;
    _pref.setPort(value);
  }

  set databaseName(String value) {
    _databaseName = value;
    _pref.setDatabaseName(value);
  }

  _getPreferences() async {
    _rdbms = await _pref.getRdbms();
    _user = await _pref.getUser();
    _pass = await _pref.getPass();
    _server = await _pref.getServer();
    _port = await _pref.getPort();
    _databaseName = await _pref.getDatabaseName();
  }

  Future<DatabaseConnectionSettings> initialize() async {
    await _getPreferences();
    return this;
  }
}

class PanelSettings {
  late String _query;
  late int _interval;
  late String _typeInterval;

  late PanelPreferences _pref;

  String get query => _query;
  int get interval => _interval;
  String get typeInterval => _typeInterval;
  PanelSettings() {
    _query = '';
    _interval = 5;
    _typeInterval = '';
    _pref = SettingsPreferences.panel;
    _getPreferences();
  }

  set query(String value) {
    _query = value;
    _pref.setQuery(value);
  }

  set interval(int value) {
    _interval = value;
    _pref.setInterval(value);
  }

  set typeInterval(String value) {
    _typeInterval = value;
    _pref.setTypeInteval(value);
  }

  _getPreferences() async {
    _query = await _pref.getQuery();
    _interval = await _pref.getInterval();
  }

  Future<PanelSettings> initialize() async {
    await _getPreferences();
    return this;
  }
}

class WinServiceSettings {
  late String _name;
  late String _status;

  late ServiceWindowsPreferences _pref;

  String get query => _name;
  String get status => _status;
  WinServiceSettings() {
    _name = '';
    _status = '';
    _pref = SettingsPreferences.winService;
    _getPreferences();
  }

  set name(String value) {
    _name = value;
    _pref.setName(value);
  }

  set status(String value) {
    _status = value;
    _pref.setStatus(value);
  }

  _getPreferences() async {
    _name = await _pref.getName();
    _status = await _pref.getStatus();
  }

  Future<WinServiceSettings> initialize() async {
    await _getPreferences();
    return this;
  }
}
