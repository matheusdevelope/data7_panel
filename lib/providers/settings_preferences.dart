import 'package:shared_preferences/shared_preferences.dart';

class SettingsPreferences {
  static NotificationsSettingsPreferences notifications =
      NotificationsSettingsPreferences();
}

class NotificationsSettingsPreferences {
  setEnabled(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(NotificationsSettingsKeys.enabled, value);
  }

  getEnabled() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(NotificationsSettingsKeys.enabled);
  }

  setFile(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(NotificationsSettingsKeys.file, value);
  }

  getFile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(NotificationsSettingsKeys.file) ?? "";
  }

  setVolume(double value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(NotificationsSettingsKeys.volume, value);
  }

  getVolume() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getDouble(NotificationsSettingsKeys.volume) == null) {
      return 1.0;
    }
    return sharedPreferences.getDouble(NotificationsSettingsKeys.volume);
  }
}

class NotificationsSettingsKeys {
  static const pre = "@NotificationsSettingsPreferences";
  static String enabled = '$pre.enabled';
  static String file = '$pre.file';
  static String volume = '$pre.volume';
}
