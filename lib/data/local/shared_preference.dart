import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/cache.dart';

class SharedPreference extends Cache {
  SharedPreferences sharedPreferences;

  SharedPreference({required this.sharedPreferences});

  @override
  Future<bool> set(String key, Object value) {
    if (value is String) {
      return sharedPreferences.setString(key, value);
    } else if (value is int) {
      return sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      return sharedPreferences.setBool(key, value);
    } else if (value is double) {
      return sharedPreferences.setDouble(key, value);
    } else {
      throw Exception("Unsupported data type found");
    }
  }

  @override
  Future<bool> delete(String key) => sharedPreferences.remove(key);

  @override
  Future<bool> reset() => sharedPreferences.clear();

  @override
  int getInt(String key, int def) => sharedPreferences.getInt(key) ?? def;

  @override
  String getString(String key, String def) =>
      sharedPreferences.getString(key) ?? def;

  @override
  bool getBool(String key, bool def) => sharedPreferences.getBool(key) ?? def;

  @override
  double getDouble(String key, double def) =>
      sharedPreferences.getDouble(key) ?? def;
}
