import 'package:data7_panel/providers/Database/database_preferences.dart';
import 'package:data7_panel/providers/Settings/settings_preferences.dart';
import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier {
  late String _rdbms;
  late String _user;
  late String _pass;
  late String _server;
  late String _port;
  late String _databaseName;
  final Map<String, String> _availableRdbms = {
    "mssql": "SQL Server",
    // "sybase": "Sybase SQL Anywhere"
  };

  late DatabasePreferences _pref;

  String get rdbms => _rdbms;
  String get user => _user;
  String get pass => _pass;
  String get server => _server;
  String get port => _port;
  String get databaseName => _databaseName;
  Map<String, String> get availableRdbms => _availableRdbms;
  DatabaseProvider() {
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
    notifyListeners();
  }

  set user(String value) {
    _user = value;
    _pref.setUser(value);
    notifyListeners();
  }

  set pass(String value) {
    _pass = value;
    _pref.setPass(value);
    notifyListeners();
  }

  set server(String value) {
    _server = value;
    _pref.setServer(value);
    notifyListeners();
  }

  set port(String value) {
    _port = value;
    _pref.setPort(value);
    notifyListeners();
  }

  set databaseName(String value) {
    _databaseName = value;
    _pref.setDatabaseName(value);
    notifyListeners();
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
  }

  Future<DatabaseProvider> initialize() async {
    await _getPreferences();
    return this;
  }
}
