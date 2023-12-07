import 'package:data7_panel/old/services/windows_service.dart';
import 'package:data7_panel/providers/Settings/settings_preferences.dart';
import 'package:data7_panel/providers/WindowsService/windows_service_preferences.dart';
import 'package:flutter/material.dart';

class WindowsServiceProvider extends ChangeNotifier {
  late String _name;
  late StatusService _status;
  late int _port;
  late String _executable;

  late WindowsServicePreferences _pref;

  String get name => _name;
  StatusService get status => _status;
  int get port => _port;
  String get executable => _executable;
  WindowsServiceProvider() {
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
  }

  Future<WindowsServiceProvider> initialize() async {
    await _getPreferences();
    return this;
  }
}
