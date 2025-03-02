import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefsService {
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  SharedPreferences? _prefs;

  factory SharedPrefsService() {
    return _instance;
  }

  SharedPrefsService._internal();

  /// Initializes SharedPreferences instance.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Saves a string value.
  Future<bool> saveString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  /// Retrieves a string value.
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  // Additional Methods
  /// Saves a DateTime value as a string.
  Future<bool> saveDateTime(String key, DateTime value) async {
    String dateString = value.toIso8601String();
    return await _prefs?.setString(key, dateString) ?? false;
  }

  /// Retrieves a DateTime value.
  DateTime? getDateTime(String key) {
    String? dateString = _prefs?.getString(key);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  /// Updates a string list by replacing it if exists or appending if it doesn't.
  Future<bool> updateOrAppendToStringList(
      String key, List<String> newList) async {
    List<String> currentList = _prefs?.getStringList(key) ?? [];
    for (String item in newList) {
      if (!currentList.contains(item)) currentList.add(item);
    }
    return await saveStringList(key, currentList);
  }

  /// Saves multiple key-value pairs in one go.
  Future<void> saveBulk(Map<String, dynamic> data) async {
    for (var entry in data.entries) {
      if (entry.value is String) {
        await saveString(entry.key, entry.value);
      } else if (entry.value is int) {
        await saveInt(entry.key, entry.value);
      } else if (entry.value is double) {
        await saveDouble(entry.key, entry.value);
      } else if (entry.value is bool) {
        await saveBool(entry.key, entry.value);
      } else if (entry.value is List<String>) {
        await saveStringList(entry.key, entry.value);
      } else if (entry.value is DateTime) {
        await saveDateTime(entry.key, entry.value);
      }
    }
  }

  /// Retrieves multiple values for a list of keys.
  Map<String, dynamic> getBulk(List<String> keys) {
    final Map<String, dynamic> result = {};
    for (String key in keys) {
      result[key] = _prefs?.get(key);
    }
    return result;
  }

  /// Removes multiple keys.
  Future<void> removeBulk(List<String> keys) async {
    for (String key in keys) {
      await remove(key);
    }
  }

  /// Increments or initializes an integer value.
  Future<int> incrementOrInitInt(String key,
      {int incrementBy = 1, int initialValue = 0}) async {
    int currentValue = _prefs?.getInt(key) ?? initialValue;
    int newValue = currentValue + incrementBy;
    await saveInt(key, newValue);
    return newValue;
  }

  /// Decrements an integer value.
  Future<int?> decrementInt(String key, {int decrementBy = 1}) async {
    int currentValue = _prefs?.getInt(key) ?? 0;
    int newValue = currentValue - decrementBy;
    await saveInt(key, newValue);
    return newValue;
  }

  /// Toggles a boolean value.
  Future<bool?> toggleBool(String key) async {
    bool currentValue = _prefs?.getBool(key) ?? false;
    bool newValue = !currentValue;
    await saveBool(key, newValue);
    return newValue;
  }

  /// Adds a single item to a list of strings.
  Future<bool> addToStringList(String key, String value) async {
    List<String> currentList = _prefs?.getStringList(key) ?? [];
    if (!currentList.contains(value)) {
      currentList.add(value);
      return await saveStringList(key, currentList);
    }
    return false;
  }

  /// Removes a single item from a list of strings.
  Future<bool> removeFromStringList(String key, String value) async {
    List<String> currentList = _prefs?.getStringList(key) ?? [];
    if (currentList.contains(value)) {
      currentList.remove(value);
      return await saveStringList(key, currentList);
    }
    return false;
  }

  /// Retrieves all key-value pairs.
  Map<String, dynamic> getAll() {
    final keys = _prefs?.getKeys() ?? {};
    final map = <String, dynamic>{};
    for (var key in keys) {
      map[key] = _prefs?.get(key);
    }
    return map;
  }

  /// Saves a JSON object by encoding it as a string.
  Future<bool> saveJson(String key, Map<String, dynamic> json) async {
    String jsonString = jsonEncode(json);
    return await _prefs?.setString(key, jsonString) ?? false;
  }

  /// Retrieves a JSON object by decoding a stored string.
  Map<String, dynamic>? getJson(String key) {
    String? jsonString = _prefs?.getString(key);
    return jsonString != null
        ? jsonDecode(jsonString) as Map<String, dynamic>
        : null;
  }

  /// Resets a list of keys to specified default values.
  Future<void> resetToDefaults(Map<String, dynamic> defaultValues) async {
    for (var entry in defaultValues.entries) {
      if (entry.value is String) {
        await saveString(entry.key, entry.value);
      } else if (entry.value is int) {
        await saveInt(entry.key, entry.value);
      } else if (entry.value is double) {
        await saveDouble(entry.key, entry.value);
      } else if (entry.value is bool) {
        await saveBool(entry.key, entry.value);
      } else if (entry.value is List<String>) {
        await saveStringList(entry.key, entry.value);
      } else if (entry.value is Map<String, dynamic>) {
        await saveJson(entry.key, entry.value);
      }
    }
  }

  /// Retrieves all keys that start with a specified prefix.
  Set<String> getKeysByPrefix(String prefix) {
    final keys = _prefs?.getKeys() ?? {};
    return keys.where((key) => key.startsWith(prefix)).toSet();
  }

  /// Counts the number of stored items.
  int getItemCount() {
    return _prefs?.getKeys().length ?? 0;
  }

  /// Batch update to increment multiple integer keys by specified values.
  Future<void> batchIncrementInts(Map<String, int> increments) async {
    for (var entry in increments.entries) {
      int currentValue = _prefs?.getInt(entry.key) ?? 0;
      int newValue = currentValue + entry.value;
      await saveInt(entry.key, newValue);
    }
  }

  /// Retrieves and removes values for a list of keys.
  Map<String, dynamic> retrieveAndRemove(List<String> keys) {
    final Map<String, dynamic> result = {};
    for (String key in keys) {
      result[key] = _prefs?.get(key);
      remove(key); // Remove the key after retrieving the value
    }
    return result;
  }

  /// Retrieves a value by type.
  T? getValue<T>(String key) {
    return _prefs?.get(key) as T?;
  }

  /// Retrieves all keys.
  Set<String>? getKeys() {
    return _prefs?.getKeys();
  }

  /// Clears all values.
  Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }

  // Basic Types
  Future<bool> saveInt(String key, int value) async =>
      await _prefs?.setInt(key, value) ?? false;
  int? getInt(String key) => _prefs?.getInt(key);

  Future<bool> saveDouble(String key, double value) async =>
      await _prefs?.setDouble(key, value) ?? false;
  double? getDouble(String key) => _prefs?.getDouble(key);

  Future<bool> saveBool(String key, bool value) async =>
      await _prefs?.setBool(key, value) ?? false;
  bool? getBool(String key) => _prefs?.getBool(key);

  Future<bool> saveStringList(String key, List<String> value) async =>
      await _prefs?.setStringList(key, value) ?? false;
  List<String>? getStringList(String key) => _prefs?.getStringList(key);

  /// Checks if a key exists.
  bool containsKey(String key) => _prefs?.containsKey(key) ?? false;

  /// Removes a value.
  Future<bool> remove(String key) async => await _prefs?.remove(key) ?? false;
}
