import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const fontSizeKey = "@";

  setFontSize(double value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(fontSizeKey, value);
  }

  getFontSize() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(fontSizeKey) ?? 14.00;
  }

  setFontSizeTitlePanel(double value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(fontSizeKey + "TitlePanel", value);
  }

  getFontSizeTitlePanel() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(fontSizeKey + "TitlePanel") ?? 14.00;
  }

  setFontSizeDataPanel(double value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(fontSizeKey + "DataPanel", value);
  }

  getFontSizeDataPanel() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(fontSizeKey + "DataPanel") ?? 14.00;
  }

  setFontSizeMenuPanel(double value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(fontSizeKey + "MenuPanel", value);
  }

  getFontSizeMenuPanel() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(fontSizeKey + "MenuPanel") ?? 14.00;
  }
}
