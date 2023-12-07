import 'package:data7_panel/providers/Panel/panel_preferences.dart';
import 'package:data7_panel/providers/Settings/settings_preferences.dart';
import 'package:flutter/material.dart';

class PanelSettings extends ChangeNotifier {
  late String _url;
  late String _query;
  late int _interval;
  late String _typeInterval;
  late bool _openAutomatic;
  final Map<String, String> _availableTypes = {
    "sec": "Segundo(s)",
    "min": "Minuto(s)",
    "hour": "Hora(s)"
  };
  late PanelPreferences _pref;
  String get url => _url;
  String get query => _query;
  int get interval => _interval;
  String get typeInterval => _typeInterval;
  bool get openAutomatic => _openAutomatic;
  Map<String, String> get availableTypes => _availableTypes;
  PanelSettings() {
    _url = '';
    _query = '';
    _interval = 5;
    _typeInterval = '';
    _openAutomatic = true;
    _pref = SettingsPreferences.panel;
    _getPreferences();
  }
  set url(String value) {
    _url = value;
    _pref.setUrl(value);
    notifyListeners();
  }

  set query(String value) {
    _query = value;
    _pref.setQuery(value);
    notifyListeners();
  }

  set interval(int value) {
    _interval = value;
    _pref.setInterval(value);
    notifyListeners();
  }

  set typeInterval(String value) {
    _typeInterval = value;
    _pref.setTypeInteval(value);
    notifyListeners();
  }

  set openAutomatic(bool value) {
    _openAutomatic = value;
    _pref.setOpenAutomatic(value);
  }

  _getPreferences() async {
    _url = await _pref.getUrl();
    _query = await _pref.getQuery() ??
        "SELECT * FROM view_QueRetornaOsDadosDoPainel";
    _interval = await _pref.getInterval();
    _typeInterval = await _pref.getTypeInteval();
    _openAutomatic = await _pref.getOpenAutomatic();
  }

  Future<PanelSettings> initialize() async {
    await _getPreferences();
    return this;
  }
}
