import 'package:data7_panel/infra/storage/storage.dart';

class WindowsServicePreferences {
  IStorage storage;
  WindowsServicePreferences({required this.storage});

  setName(String value) async {
    await storage.setString(WindowsServiceSettingsKeys.name, value);
  }

  getName() async {
    return await storage.getString(WindowsServiceSettingsKeys.name) ??
        'Data7Panel';
  }

  setStatus(String value) async {
    await storage.setString(WindowsServiceSettingsKeys.status, value);
  }

  getStatus() async {
    return await storage.getString(WindowsServiceSettingsKeys.status) ?? "";
  }

  setPort(int value) async {
    await storage.setInt(WindowsServiceSettingsKeys.port, value);
  }

  getPort() async {
    return await storage.getInt(WindowsServiceSettingsKeys.port) ?? 3546;
  }
}

class WindowsServiceSettingsKeys {
  static const pre = "@WindowsServiceSettingsPreferences";
  static String name = '$pre.name';
  static String status = '$pre.status';
  static String port = '$pre.port';
}
