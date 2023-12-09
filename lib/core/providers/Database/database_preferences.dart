import 'package:data7_panel/core/infra/storage/storage.dart';

class DatabasePreferences {
  IStorage storage;
  DatabasePreferences({required this.storage});
  setRdbms(String value) async {
    await storage.setString(DatabaseSettingsKeys.rdbms, value);
  }

  setUser(String value) async {
    await storage.setString(DatabaseSettingsKeys.user, value);
  }

  setPass(String value) async {
    await storage.setString(DatabaseSettingsKeys.pass, value);
  }

  setServer(String value) async {
    await storage.setString(DatabaseSettingsKeys.server, value);
  }

  setPort(String value) async {
    await storage.setString(DatabaseSettingsKeys.port, value);
  }

  setDatabaseName(String value) async {
    await storage.setString(DatabaseSettingsKeys.databaseName, value);
  }

  getRdbms() async {
    return await storage.getString(DatabaseSettingsKeys.rdbms) ?? '';
  }

  getUser() async {
    return await storage.getString(DatabaseSettingsKeys.user) ?? '';
  }

  getPass() async {
    return await storage.getString(DatabaseSettingsKeys.pass) ?? '';
  }

  getServer() async {
    return await storage.getString(DatabaseSettingsKeys.server) ?? '';
  }

  getPort() async {
    return await storage.getString(DatabaseSettingsKeys.port) ?? '';
  }

  getDatabaseName() async {
    return await storage.getString(DatabaseSettingsKeys.databaseName) ?? '';
  }
}

class DatabaseSettingsKeys {
  static const pre = "@DatabaseConectionSettingsPreferences";
  static String rdbms = '$pre.rdbms';
  static String user = '$pre.user';
  static String pass = '$pre.pass';
  static String server = '$pre.server';
  static String port = '$pre.port';
  static String databaseName = '$pre.databaseName';
}
