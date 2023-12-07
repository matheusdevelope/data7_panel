import 'package:data7_panel/providers/Theme/theme_preferences.dart';
import 'package:data7_panel/providers/Settings/settings_preferences.dart';
import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  late double _fontSize;
  late double _fontSizeTitlePanel;
  late double _fontSizeDataPanel;
  late double _fontSizeMenuPanel;
  late bool _useAdaptiveTheme;
  late ThemePreferences _preferences;
  double get fontSize => _fontSize;
  double get fontSizeTitlePanel => _fontSizeTitlePanel;
  double get fontSizeDataPanel => _fontSizeDataPanel;
  double get fontSizeMenuPanel => _fontSizeMenuPanel;
  bool get useAdaptiveTheme => _useAdaptiveTheme;

  ThemeModel() {
    _fontSize = 14;
    _fontSizeTitlePanel = 14;
    _fontSizeDataPanel = 14;
    _fontSizeMenuPanel = 14;
    _useAdaptiveTheme = true;
    _preferences = SettingsPreferences.theme;
    getPreferences();
  }

  set fontSize(double value) {
    _fontSize = value;
    _preferences.setFontSize(value);
    notifyListeners();
  }

  set fontSizeTitlePanel(double value) {
    _fontSizeTitlePanel = value;
    _preferences.setFontSizeTitlePanel(value);
    notifyListeners();
  }

  set fontSizeDataPanel(double value) {
    _fontSizeDataPanel = value;
    _preferences.setFontSizeDataPanel(value);
    notifyListeners();
  }

  set fontSizeMenuPanel(double value) {
    _fontSizeMenuPanel = value;
    _preferences.setFontSizeMenuPanel(value);
    notifyListeners();
  }

  set useAdaptiveTheme(bool value) {
    _useAdaptiveTheme = value;
    _preferences.setUseAdaptiveTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _fontSize = await _preferences.getFontSize();
    _fontSizeTitlePanel = await _preferences.getFontSizeTitlePanel();
    _fontSizeDataPanel = await _preferences.getFontSizeDataPanel();
    _fontSizeMenuPanel = await _preferences.getFontSizeMenuPanel();
    _useAdaptiveTheme = await _preferences.getUseAdaptiveTheme();
    notifyListeners();
  }

  Future<ThemeModel> initialize() async {
    await getPreferences();
    return this;
  }
}
