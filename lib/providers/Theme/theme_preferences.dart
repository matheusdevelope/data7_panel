import 'package:data7_panel/infra/storage/storage.dart';

class ThemePreferences {
  IStorage storage;
  ThemePreferences({required this.storage});

  static const fontSizeKey = "@";

  setFontSize(double value) async {
    await storage.setDouble(fontSizeKey, value);
  }

  getFontSize() async {
    return await storage.getDouble(fontSizeKey) ?? 14.00;
  }

  setFontSizeTitlePanel(double value) async {
    await storage.setDouble("${fontSizeKey}TitlePanel", value);
  }

  getFontSizeTitlePanel() async {
    return await storage.getDouble("${fontSizeKey}TitlePanel") ?? 14.00;
  }

  setFontSizeDataPanel(double value) async {
    await storage.setDouble("${fontSizeKey}DataPanel", value);
  }

  getFontSizeDataPanel() async {
    return await storage.getDouble("${fontSizeKey}DataPanel") ?? 14.00;
  }

  setFontSizeMenuPanel(double value) async {
    await storage.setDouble("${fontSizeKey}MenuPanel", value);
  }

  getFontSizeMenuPanel() async {
    return await storage.getDouble("${fontSizeKey}MenuPanel") ?? 14.00;
  }

  setUseAdaptiveTheme(bool value) async {
    await storage.setBool("${fontSizeKey}UseAdaptiveTheme", value);
  }

  getUseAdaptiveTheme() async {
    return await storage.getBool("${fontSizeKey}UseAdaptiveTheme") ?? true;
  }
}
