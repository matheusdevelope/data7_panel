import 'package:shared_preferences/shared_preferences.dart';

class SettingsPreferences {
  static NotificationsSettingsPreferences notifications =
      NotificationsSettingsPreferences();
  static DatabaseConnectionPreferences database =
      DatabaseConnectionPreferences();
  static PanelPreferences panel = PanelPreferences();
  static ServiceWindowsPreferences winService = ServiceWindowsPreferences();
}

class NotificationsSettingsPreferences {
  setEnabled(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(NotificationsSettingsKeys.enabled, value);
  }

  getEnabled() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(NotificationsSettingsKeys.enabled) ?? true;
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

class DatabaseConnectionPreferences {
  setRdbms(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(DatabaseConnectionSettingsKeys.rdbms, value);
  }

  setUser(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(DatabaseConnectionSettingsKeys.user, value);
  }

  setPass(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(DatabaseConnectionSettingsKeys.pass, value);
  }

  setServer(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(DatabaseConnectionSettingsKeys.server, value);
  }

  setPort(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(DatabaseConnectionSettingsKeys.port, value);
  }

  setDatabaseName(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        DatabaseConnectionSettingsKeys.databaseName, value);
  }

  setDatabaseSchema(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        DatabaseConnectionSettingsKeys.databaseSchema, value);
  }

  getRdbms() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(DatabaseConnectionSettingsKeys.rdbms) ??
        '';
  }

  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(DatabaseConnectionSettingsKeys.user) ??
        '';
  }

  getPass() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(DatabaseConnectionSettingsKeys.pass) ??
        '';
  }

  getServer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(DatabaseConnectionSettingsKeys.server) ??
        '';
  }

  getPort() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(DatabaseConnectionSettingsKeys.port) ??
        '';
  }

  getDatabaseName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences
            .getString(DatabaseConnectionSettingsKeys.databaseName) ??
        '';
  }

  getDatabaseSchema() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences
            .getString(DatabaseConnectionSettingsKeys.databaseSchema) ??
        '';
  }
}

class DatabaseConnectionSettingsKeys {
  static const pre = "@DatabaseConectionSettingsPreferences";
  static String rdbms = '$pre.rdbms';
  static String user = '$pre.user';
  static String pass = '$pre.pass';
  static String server = '$pre.server';
  static String port = '$pre.port';
  static String databaseName = '$pre.databaseName';
  static String databaseSchema = '$pre.databaseSchema';
}

class PanelPreferences {
  setUrl(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(PanelSettingsKeys.url, value);
  }

  getUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(PanelSettingsKeys.url) ?? "";
  }

  setDescription(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(PanelSettingsKeys.description, value);
  }

  getDescription() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(PanelSettingsKeys.description) ?? "";
  }

  setQuery(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(PanelSettingsKeys.query, value);
  }

  getQuery() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(PanelSettingsKeys.query);
  }

  setInterval(int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(PanelSettingsKeys.interval, value);
  }

  setDuration(int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(PanelSettingsKeys.duration, value);
  }

  getInterval() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(PanelSettingsKeys.interval) ?? 5;
  }

  getDuration() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(PanelSettingsKeys.duration) ?? 5;
  }

  setTypeInteval(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(PanelSettingsKeys.typeInteval, value);
  }

  getTypeInteval() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(PanelSettingsKeys.typeInteval) ?? 'sec';
  }

  getTypeIntevalDuration() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(PanelSettingsKeys.typeIntevalDuration) ??
        'sec';
  }

  setTypeIntervalDuration(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(PanelSettingsKeys.typeIntevalDuration, value);
  }

  setOpenAutomatic(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(PanelSettingsKeys.openAutomatic, value);
  }

  getOpenAutomatic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(PanelSettingsKeys.openAutomatic) ?? true;
  }
}

class PanelSettingsKeys {
  static const pre = "@PanelSettingsPreferences";
  static String url = '$pre.url';
  static String description = '$pre.description';
  static String query = '$pre.query';
  static String interval = '$pre.interval';
  static String duration = '$pre.duration';
  static String typeInteval = '$pre.typeInteval';
  static String typeIntevalDuration = '$pre.typeIntevalDuration';
  static String openAutomatic = '$pre.openAutomatic';
}

class ServiceWindowsPreferences {
  setName(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(ServiceWindowsSettingsKeys.name, value);
  }

  getName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(ServiceWindowsSettingsKeys.name) ??
        'Data7Panel';
  }

  setStatus(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(ServiceWindowsSettingsKeys.status, value);
  }

  getStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(ServiceWindowsSettingsKeys.status) ?? "";
  }

  setPort(int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(ServiceWindowsSettingsKeys.port, value);
  }

  getPort() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(ServiceWindowsSettingsKeys.port) ?? 3546;
  }
}

class ServiceWindowsSettingsKeys {
  static const pre = "@ServiceWindowsSettingsPreferences";
  static String name = '$pre.name';
  static String status = '$pre.status';
  static String port = '$pre.port';
}
