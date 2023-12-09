abstract class IStorage {
  Future<bool> setString(String key, String value);
  Future<String>? getString(String key);
  Future<bool> setBool(String key, bool value);
  Future<bool>? getBool(String key);
  Future<bool> setInt(String key, int value);
  Future<int>? getInt(String key);
  Future<bool> setDouble(String key, double value);
  Future<double>? getDouble(String key);
  Future<bool> setStringList(String key, List<String> value);
  Future<List<String>>? getStringList(String key);
  Future<bool> setMap<T>(String key, Map<String, T> value);
  Future<Map<String, T>>? getMap<T>(String key);
  Future<bool> setList<T>(String key, List<T> value);
  Future<List<T>>? getList<T>(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
}
