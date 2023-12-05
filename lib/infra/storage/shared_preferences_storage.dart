import 'dart:convert';

import 'package:data7_panel/infra/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage implements IStorage {
  SharedPreferences? _preferences;
  SharedPreferencesStorage() {
    init();
  }
  init() async {
    if (_preferences != null) return;
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Future<bool> setString(String key, String value) async {
    await init();
    return _preferences!.setString(key, value);
  }

  @override
  Future<String> getString(String key) async {
    await init();
    return Future.value(_preferences!.getString(key) ?? '');
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    await init();
    return _preferences!.setBool(key, value);
  }

  @override
  Future<bool> getBool(String key) async {
    await init();
    return Future.value(_preferences!.getBool(key) ?? false);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    await init();
    return _preferences!.setInt(key, value);
  }

  @override
  Future<int> getInt(String key) async {
    await init();
    return Future.value(_preferences!.getInt(key) ?? 0);
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    await init();
    return _preferences!.setDouble(key, value);
  }

  @override
  Future<double> getDouble(String key) async {
    await init();
    return Future.value(_preferences!.getDouble(key) ?? 0.0);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    await init();
    return _preferences!.setStringList(key, value);
  }

  @override
  Future<List<String>> getStringList(String key) async {
    await init();
    return Future.value(_preferences!.getStringList(key) ?? []);
  }

  @override
  Future<bool> setMap<T>(String key, Map<String, T> value) async {
    await init();
    return _preferences!.setString(key, jsonEncode(value));
  }

  @override
  Future<Map<String, T>> getMap<T>(String key) async {
    await init();
    return Future.value(
        jsonDecode(_preferences!.getString(key) ?? '{}') as Map<String, T>);
  }

  @override
  Future<bool> setList<T>(String key, List<T> value) async {
    await init();
    return _preferences!.setString(key, jsonEncode(value));
  }

  @override
  Future<List<T>> getList<T>(String key) async {
    await init();
    return Future.value(
        jsonDecode(_preferences!.getString(key) ?? '[]') as List<T>);
  }

  @override
  Future<bool> remove(String key) async {
    await init();
    return _preferences!.remove(key);
  }

  @override
  Future<bool> clear() async {
    await init();
    return _preferences!.clear();
  }
}
