import 'package:data7_panel/core/infra/storage/storage.dart';

class NotificationPreferences {
  IStorage storage;
  NotificationPreferences({required this.storage});
  setEnabled(bool value) async {
    await storage.setBool(NotificationsSettingsKeys.enabled, value);
  }

  getEnabled() async {
    return await storage.getBool(NotificationsSettingsKeys.enabled) ?? true;
  }

  setFile(String value) async {
    await storage.setString(NotificationsSettingsKeys.file, value);
  }

  getFile() async {
    return await storage.getString(NotificationsSettingsKeys.file) ?? "";
  }

  setVolume(double value) async {
    await storage.setDouble(NotificationsSettingsKeys.volume, value);
  }

  getVolume() async {
    final volume = await storage.getDouble(NotificationsSettingsKeys.volume);
    if (volume == null) {
      return 1.0;
    }
    return volume;
  }
}

class NotificationsSettingsKeys {
  static const pre = "@NotificationsSettingsPreferences";
  static String enabled = '$pre.enabled';
  static String file = '$pre.file';
  static String volume = '$pre.volume';
}
