import 'package:data7_panel/infra/storage/storage.dart';

class PanelPreferences {
  IStorage storage;
  PanelPreferences({required this.storage});

  setUrl(String value) async {
    await storage.setString(PanelSettingsKeys.url, value);
  }

  getUrl() async {
    return await storage.getString(PanelSettingsKeys.url) ?? "";
  }

  setQuery(String value) async {
    await storage.setString(PanelSettingsKeys.query, value);
  }

  getQuery() async {
    return await storage.getString(PanelSettingsKeys.query);
  }

  setInterval(int value) async {
    await storage.setInt(PanelSettingsKeys.interval, value);
  }

  getInterval() async {
    return await storage.getInt(PanelSettingsKeys.interval) ?? 5;
  }

  setTypeInteval(String value) async {
    await storage.setString(PanelSettingsKeys.typeInteval, value);
  }

  getTypeInteval() async {
    return await storage.getString(PanelSettingsKeys.typeInteval) ?? 'sec';
  }

  setOpenAutomatic(bool value) async {
    await storage.setBool(PanelSettingsKeys.openAutomatic, value);
  }

  getOpenAutomatic() async {
    return await storage.getBool(PanelSettingsKeys.openAutomatic) ?? true;
  }
}

class PanelSettingsKeys {
  static const pre = "@PanelSettingsPreferences";
  static String url = '$pre.url';
  static String query = '$pre.query';
  static String interval = '$pre.interval';
  static String typeInteval = '$pre.typeInteval';
  static String openAutomatic = '$pre.openAutomatic';
}
