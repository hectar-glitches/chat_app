import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences? _preferences;

  // Initialize the SharedPreferences instance
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Store a string value
  static Future<bool> setString(String key, String value) async {
    if (_preferences == null) await init();
    return await _preferences!.setString(key, value);
  }

  // Retrieve a string value
  static String getString(String key, {String defaultValue = ''}) {
    if (_preferences == null) return defaultValue;
    return _preferences!.getString(key) ?? defaultValue;
  }

  // Store a boolean value
  static Future<bool> setBool(String key, bool value) async {
    if (_preferences == null) await init();
    return await _preferences!.setBool(key, value);
  }

  // Retrieve a boolean value
  static bool getBool(String key, {bool defaultValue = false}) {
    if (_preferences == null) return defaultValue;
    return _preferences!.getBool(key) ?? defaultValue;
  }

  // Store a list of strings
  static Future<bool> setStringList(String key, List<String> value) async {
    if (_preferences == null) await init();
    return await _preferences!.setStringList(key, value);
  }

  // Retrieve a list of strings
  static List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    if (_preferences == null) return defaultValue;
    return _preferences!.getStringList(key) ?? defaultValue;
  }

  // Store an object
  static Future<bool> setObject(String key, Map<String, dynamic> value) async {
    if (_preferences == null) await init();
    return await _preferences!.setString(key, json.encode(value));
  }

  // Retrieve an object
  static Map<String, dynamic> getObject(String key, {Map<String, dynamic> defaultValue = const {}}) {
    if (_preferences == null) return defaultValue;
    final String data = _preferences!.getString(key) ?? '';
    if (data.isEmpty) return defaultValue;
    try {
      return json.decode(data);
    } catch (e) {
      return defaultValue;
    }
  }

  // Store a list of objects
  static Future<bool> setObjectList(String key, List<Map<String, dynamic>> value) async {
    if (_preferences == null) await init();
    return await _preferences!.setString(key, json.encode(value));
  }

  // Retrieve a list of objects
  static List<Map<String, dynamic>> getObjectList(String key, {List<Map<String, dynamic>> defaultValue = const []}) {
    if (_preferences == null) return defaultValue;
    final String data = _preferences!.getString(key) ?? '';
    if (data.isEmpty) return defaultValue;
    try {
      final List<dynamic> decoded = json.decode(data);
      return decoded.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      return defaultValue;
    }
  }

  // Remove a value
  static Future<bool> remove(String key) async {
    if (_preferences == null) await init();
    return await _preferences!.remove(key);
  }

  // Clear all values
  static Future<bool> clear() async {
    if (_preferences == null) await init();
    return await _preferences!.clear();
  }
}
