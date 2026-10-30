import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A comprehensive utility service for managing persistent key-value storage
/// with [SharedPreferences].
class SharedPrefsService {
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  SharedPreferences? _prefs;

  factory SharedPrefsService() {
    return _instance;
  }

  SharedPrefsService._internal();

  /// Whether the [SharedPreferences] instance has been initialized.
  bool get isInitialized => _prefs != null;

  /// The raw [SharedPreferences] instance, if initialized.
  SharedPreferences? get prefs => _prefs;

  /// Initializes the singleton with the platform's default [SharedPreferences] instance.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Initializes the service with a provided [SharedPreferences] instance.
  ///
  /// Useful for testing and dependency injection.
  void initWithInstance(SharedPreferences prefs) {
    _prefs = prefs;
  }

  /// Reloads preference values from persistent storage.
  Future<void> reload() async {
    await _prefs?.reload();
  }

  // Basic Types

  /// Saves a string value.
  Future<bool> saveString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  /// Retrieves a string value.
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Saves an integer value.
  Future<bool> saveInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }

  /// Retrieves an integer value.
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// Saves a double value.
  Future<bool> saveDouble(String key, double value) async {
    return await _prefs?.setDouble(key, value) ?? false;
  }

  /// Retrieves a double value.
  double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  /// Saves a boolean value.
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  /// Retrieves a boolean value.
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// Saves a list of strings.
  Future<bool> saveStringList(String key, List<String> value) async {
    return await _prefs?.setStringList(key, value) ?? false;
  }

  /// Retrieves a list of strings.
  List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  // DateTime Support

  /// Saves a [DateTime] value serialized in ISO-8601 format.
  Future<bool> saveDateTime(String key, DateTime value) async {
    final dateString = value.toIso8601String();
    return await _prefs?.setString(key, dateString) ?? false;
  }

  /// Retrieves a [DateTime] value, or `null` if the key does not exist or cannot be parsed.
  DateTime? getDateTime(String key) {
    final dateString = _prefs?.getString(key);
    if (dateString == null) return null;
    return DateTime.tryParse(dateString);
  }

  // JSON Support

  /// Encodes and saves a JSON map as a string.
  Future<bool> saveJson(String key, Map<String, dynamic> json) async {
    final jsonString = jsonEncode(json);
    return await _prefs?.setString(key, jsonString) ?? false;
  }

  /// Retrieves and decodes a stored JSON map, or `null` if not found or corrupted.
  Map<String, dynamic>? getJson(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.cast<String, dynamic>();
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  // List Operations

  /// Updates a string list by adding unique entries from [newList] to the existing list.
  Future<bool> updateOrAppendToStringList(
      String key, List<String> newList) async {
    final currentList =
        List<String>.from(_prefs?.getStringList(key) ?? const []);
    for (final item in newList) {
      if (!currentList.contains(item)) {
        currentList.add(item);
      }
    }
    return await saveStringList(key, currentList);
  }

  /// Adds a single unique item to a list of strings. Returns true if added.
  Future<bool> addToStringList(String key, String value) async {
    final currentList =
        List<String>.from(_prefs?.getStringList(key) ?? const []);
    if (!currentList.contains(value)) {
      currentList.add(value);
      return await saveStringList(key, currentList);
    }
    return false;
  }

  /// Removes a single item from a list of strings. Returns true if removed.
  Future<bool> removeFromStringList(String key, String value) async {
    final currentList =
        List<String>.from(_prefs?.getStringList(key) ?? const []);
    if (currentList.contains(value)) {
      currentList.remove(value);
      return await saveStringList(key, currentList);
    }
    return false;
  }

  // Number & Boolean Helpers

  /// Increments an integer by [incrementBy] or initializes it to [initialValue] + [incrementBy].
  Future<int> incrementOrInitInt(
    String key, {
    int incrementBy = 1,
    int initialValue = 0,
  }) async {
    final currentValue = _prefs?.getInt(key) ?? initialValue;
    final newValue = currentValue + incrementBy;
    await saveInt(key, newValue);
    return newValue;
  }

  /// Decrements an integer key by [decrementBy].
  Future<int> decrementInt(String key, {int decrementBy = 1}) async {
    final currentValue = _prefs?.getInt(key) ?? 0;
    final newValue = currentValue - decrementBy;
    await saveInt(key, newValue);
    return newValue;
  }

  /// Toggles a boolean key (defaults to false before toggle).
  Future<bool> toggleBool(String key) async {
    final currentValue = _prefs?.getBool(key) ?? false;
    final newValue = !currentValue;
    await saveBool(key, newValue);
    return newValue;
  }

  /// Increments multiple integer keys in a single operation.
  Future<void> batchIncrementInts(Map<String, int> increments) async {
    for (final entry in increments.entries) {
      final currentValue = _prefs?.getInt(entry.key) ?? 0;
      final newValue = currentValue + entry.value;
      await saveInt(entry.key, newValue);
    }
  }

  // Bulk Operations

  /// Saves multiple key-value pairs in one go based on their runtime types.
  Future<void> saveBulk(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      final value = entry.value;
      if (value is String) {
        await saveString(entry.key, value);
      } else if (value is int) {
        await saveInt(entry.key, value);
      } else if (value is double) {
        await saveDouble(entry.key, value);
      } else if (value is bool) {
        await saveBool(entry.key, value);
      } else if (value is List<String>) {
        await saveStringList(entry.key, value);
      } else if (value is DateTime) {
        await saveDateTime(entry.key, value);
      } else if (value is Map<String, dynamic>) {
        await saveJson(entry.key, value);
      }
    }
  }

  /// Retrieves multiple values for a list of keys.
  Map<String, dynamic> getBulk(List<String> keys) {
    final Map<String, dynamic> result = {};
    for (final key in keys) {
      result[key] = _prefs?.get(key);
    }
    return result;
  }

  /// Removes multiple keys at once.
  Future<void> removeBulk(List<String> keys) async {
    for (final key in keys) {
      await remove(key);
    }
  }

  /// Resets specified keys to their given default values.
  Future<void> resetToDefaults(Map<String, dynamic> defaultValues) async {
    await saveBulk(defaultValues);
  }

  /// Retrieves values for keys and removes the keys from storage.
  Future<Map<String, dynamic>> retrieveAndRemove(List<String> keys) async {
    final Map<String, dynamic> result = {};
    for (final key in keys) {
      result[key] = _prefs?.get(key);
      await remove(key);
    }
    return result;
  }

  // Inspection & Querying

  /// Retrieves all key-value pairs stored in preferences.
  Map<String, dynamic> getAll() {
    final keys = _prefs?.getKeys() ?? <String>{};
    final map = <String, dynamic>{};
    for (final key in keys) {
      map[key] = _prefs?.get(key);
    }
    return map;
  }

  /// Retrieves all keys currently stored.
  Set<String> getKeys() {
    return _prefs?.getKeys() ?? <String>{};
  }

  /// Retrieves all keys that start with [prefix].
  Set<String> getKeysByPrefix(String prefix) {
    final keys = _prefs?.getKeys() ?? <String>{};
    return keys.where((key) => key.startsWith(prefix)).toSet();
  }

  /// Total number of keys currently stored.
  int getItemCount() {
    return _prefs?.getKeys().length ?? 0;
  }

  /// Retrieves a value cast to type [T], or `null` if missing or invalid type.
  T? getValue<T>(String key) {
    final value = _prefs?.get(key);
    return value is T ? value : null;
  }

  /// Checks if a key exists in preferences.
  bool containsKey(String key) => _prefs?.containsKey(key) ?? false;

  /// Removes a single key.
  Future<bool> remove(String key) async => await _prefs?.remove(key) ?? false;

  /// Clears all keys from preferences.
  Future<bool> clear() async => await _prefs?.clear() ?? false;
}
