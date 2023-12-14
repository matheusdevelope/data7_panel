import 'package:data7_panel/models/options_from_url.dart';
import 'package:data7_panel/providers/caroussel_model.dart';
import 'package:data7_panel/providers/settings_preferences.dart';
import 'package:data7_panel/providers/theme_model.dart';
import 'package:data7_panel/services/NotificationHelper.dart';
import 'package:data7_panel/services/windows_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  static ThemeModel theme = ThemeModel();
  static PanelSettings panel = PanelSettings();
  static CarousselModel carrossel = CarousselModel();
  static NotificationsSettings notifications = NotificationsSettings();
  static DatabaseConnectionSettings db = DatabaseConnectionSettings();
  static WinServiceSettings winService = WinServiceSettings();

  late WinServiceSettings _winService;
  WinServiceSettings get pWinService => _winService;
  Settings() {
    _winService = WinServiceSettings();
  }
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
  late String _databaseSchema;
  final Map<String, String> _availableRdbms = {
    "mssql": "SQL Server",
    // "sybase": "Sybase SQL Anywhere"
  };

  late DatabaseConnectionPreferences _pref;

  String get rdbms => _rdbms;
  String get user => _user;
  String get pass => _pass;
  String get server => _server;
  String get port => _port;
  String get databaseName => _databaseName;
  String get databaseSchema => _databaseSchema;
  Map<String, String> get availableRdbms => _availableRdbms;
  DatabaseConnectionSettings() {
    _rdbms = '';
    _user = '';
    _pass = '';
    _server = '';
    _port = '';
    _databaseName = '';
    _databaseSchema = '';
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

  set databaseSchema(String value) {
    _databaseSchema = value;
    _pref.setDatabaseSchema(value);
  }

  _getPreferences() async {
    _rdbms = await _pref.getRdbms();
    if (_rdbms.isEmpty) {
      _rdbms = _availableRdbms.keys.first;
    }
    _user = await _pref.getUser();
    _pass = await _pref.getPass();
    _server = await _pref.getServer();
    _port = await _pref.getPort();
    _databaseName = await _pref.getDatabaseName();
    _databaseSchema = await _pref.getDatabaseSchema();
  }

  Future<DatabaseConnectionSettings> initialize() async {
    await _getPreferences();
    return this;
  }
}

class PanelSettings {
  late String _url;
  late ColumnsOptions _colsOptions;
  late String _description;
  late String _query;
  late int _interval;
  late int _duration;
  late String _typeInterval;
  late String _typeIntervalDuration;
  late bool _openAutomatic;
  final Map<String, String> _availableTypes = {
    "sec": "Segundo(s)",
    "min": "Minuto(s)",
    "hour": "Hora(s)"
  };
  late PanelPreferences _pref;
  String get url => _url;
  ColumnsOptions get colsOptions => _colsOptions;
  String get query => _query;
  String get description => _description;
  int get interval => _interval;
  int get duration => _duration;
  String get typeInterval => _typeInterval;
  String get typeIntervalDuration => _typeIntervalDuration;
  bool get openAutomatic => _openAutomatic;
  Map<String, String> get availableTypes => _availableTypes;
  PanelSettings() {
    _url = '';
    _colsOptions = ColumnsOptions(url: '');
    _query = '';
    _description = '';
    _interval = 5;
    _typeInterval = '';
    _openAutomatic = true;
    _pref = SettingsPreferences.panel;
    _getPreferences();
  }
  set url(String value) {
    _url = value;
    _colsOptions = ColumnsOptions(url: value);
    _pref.setUrl(value);
  }

  set description(String value) {
    _description = value;
    _pref.setDescription(value);
  }

  set query(String value) {
    _query = value;
    _pref.setQuery(value);
  }

  set interval(int value) {
    _interval = value;
    _pref.setInterval(value);
  }

  set duration(int value) {
    _duration = value;
    _pref.setDuration(value);
  }

  set typeInterval(String value) {
    _typeInterval = value;
    _pref.setTypeInteval(value);
  }

  set typeIntervalDuration(String value) {
    _typeIntervalDuration = value;
    _pref.setTypeIntervalDuration(value);
  }

  set openAutomatic(bool value) {
    _openAutomatic = value;
    _pref.setOpenAutomatic(value);
  }

  _getPreferences() async {
    _url = await _pref.getUrl();
    _colsOptions = ColumnsOptions(url: _url);
    _description = await _pref.getDescription();
    _query = await _pref.getQuery() ??
        "SELECT * FROM view_QueRetornaOsDadosDoPainel";
    _interval = await _pref.getInterval();
    _typeInterval = await _pref.getTypeInteval();
    _duration = await _pref.getDuration();
    _typeIntervalDuration = await _pref.getTypeIntevalDuration();
    _openAutomatic = await _pref.getOpenAutomatic();
  }

  Future<PanelSettings> initialize() async {
    await _getPreferences();
    return this;
  }
}

class WinServiceSettings extends ChangeNotifier {
  late String _name;
  late StatusService _status;
  late int _port;
  late String _executable;

  late ServiceWindowsPreferences _pref;

  String get name => _name;
  StatusService get status => _status;
  int get port => _port;
  String get executable => _executable;
  WinServiceSettings() {
    _name = '';
    _status = StatusService.pending;
    _port = 3546;
    _executable = '';
    _pref = SettingsPreferences.winService;
    _getPreferences();
  }

  set name(String value) {
    _name = value;
    _pref.setName(value);
    notifyListeners();
  }

  set status(StatusService value) {
    _status = value;
    _pref.setStatus(value.name);
    notifyListeners();
  }

  set port(int value) {
    _port = value;
    _pref.setPort(value);
    notifyListeners();
  }

  _getPreferences() async {
    _name = await _pref.getName();
    String tempStatus = await _pref.getStatus();
    for (var element in StatusService.values) {
      if (element.name == tempStatus) {
        _status = element;
      }
    }
    _port = await _pref.getPort();
    _executable = await FileWindowService.getServiceExecutable();

    notifyListeners();
  }

  Future<WinServiceSettings> initialize() async {
    await _getPreferences();
    return this;
  }
}
