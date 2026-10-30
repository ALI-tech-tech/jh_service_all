# jh_sharedprefs

[![pub package](https://img.shields.io/pub/v/jh_sharedprefs.svg)](https://pub.dev/packages/jh_sharedprefs)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A comprehensive, developer-friendly persistent storage wrapper for Flutter applications powered by [shared_preferences](https://pub.dev/packages/shared_preferences).

It simplifies data persistence with out-of-the-box support for primitive types, `DateTime`, structured `JSON` maps, list manipulations, atomic numeric helpers, and bulk operations.

---

## Features

- **All Standard Primitives:** Read and write `String`, `int`, `double`, `bool`, and `List<String>`.
- **Extended Types:** Seamlessly store and retrieve ISO-8601 `DateTime` objects and complex `Map<String, dynamic>` JSON structures.
- **Convenient Number & Bool Helpers:** `incrementOrInitInt`, `decrementInt`, `toggleBool`, and `batchIncrementInts`.
- **List Operations:** Easily add, remove, or append unique entries to string lists without worrying about immutable list restrictions.
- **Bulk & Batch Utilities:** `saveBulk`, `getBulk`, `removeBulk`, `resetToDefaults`, and atomic `retrieveAndRemove`.
- **Inspect & Query:** `getKeysByPrefix`, `getItemCount`, and `getAll`.
- **Test-Friendly:** Inject mock or custom `SharedPreferences` instances via `initWithInstance` for unit testing.

---

## Installation

Add `jh_sharedprefs` to your `pubspec.yaml`:

```yaml
dependencies:
  jh_sharedprefs: ^1.0.0
```

Then install dependencies:

```bash
flutter pub get
```

---

## Quick Start

### 1. Initialization

Initialize the service before running your app (typically inside `main`):

```dart
import 'package:flutter/material.dart';
import 'package:jh_sharedprefs/jh_sharedprefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService().init();
  runApp(const MyApp());
}
```

### 2. Basic Storage

```dart
final prefs = SharedPrefsService();

// Save data
await prefs.saveString('username', 'Ali');
await prefs.saveInt('score', 100);
await prefs.saveDouble('rating', 4.9);
await prefs.saveBool('isDarkMode', true);
await prefs.saveStringList('tags', ['flutter', 'dart']);

// Retrieve data
String? username = prefs.getString('username');
int? score = prefs.getInt('score');
bool? isDarkMode = prefs.getBool('isDarkMode');
```

### 3. Storing DateTime & JSON

```dart
// DateTime
await prefs.saveDateTime('lastLogin', DateTime.now());
DateTime? lastLogin = prefs.getDateTime('lastLogin');

// JSON Map
await prefs.saveJson('userProfile', {
  'id': 123,
  'name': 'Ali Ben Jahlan',
  'roles': ['admin', 'developer'],
});
Map<String, dynamic>? profile = prefs.getJson('userProfile');
```

### 4. Numeric & Boolean Helpers

```dart
// Increment integer by 1 (or initialize to 0 + 1)
int newScore = await prefs.incrementOrInitInt('score');

// Decrement integer
int remaining = await prefs.decrementInt('attempts', decrementBy: 1);

// Toggle boolean
bool isEnabled = await prefs.toggleBool('notificationsEnabled');

// Batch increment counters
await prefs.batchIncrementInts({
  'pageViews': 1,
  'clicks': 5,
});
```

### 5. String List Manipulation

```dart
// Add a single unique item
await prefs.addToStringList('tags', 'mobile');

// Remove an item
await prefs.removeFromStringList('tags', 'dart');

// Append multiple items uniquely
await prefs.updateOrAppendToStringList('tags', ['android', 'ios']);
```

### 6. Bulk Operations & Queries

```dart
// Save multiple items at once
await prefs.saveBulk({
  'theme': 'dark',
  'fontSize': 14,
  'autoSave': true,
});

// Retrieve multiple items
Map<String, dynamic> settings = prefs.getBulk(['theme', 'fontSize']);

// Retrieve and remove keys
Map<String, dynamic> sessionData = await prefs.retrieveAndRemove(['token', 'tempId']);

// Query keys by prefix
Set<String> authKeys = prefs.getKeysByPrefix('auth_');
```

---

## Testing

For unit testing, you can initialize the service with mock data using `initWithInstance`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jh_sharedprefs/jh_sharedprefs.dart';

void main() {
  test('unit test with mocked SharedPreferences', () async {
    SharedPreferences.setMockInitialValues({'username': 'TestUser'});
    final mockPrefs = await SharedPreferences.getInstance();
    
    SharedPrefsService().initWithInstance(mockPrefs);

    expect(SharedPrefsService().getString('username'), 'TestUser');
  });
}
```

---

## API Summary

| Method | Return Type | Description |
|---|---|---|
| `init()` | `Future<void>` | Initializes the default `SharedPreferences` instance. |
| `initWithInstance(prefs)` | `void` | Injects a custom `SharedPreferences` instance. |
| `reload()` | `Future<void>` | Reloads cached preferences from disk. |
| `saveString(key, val)` | `Future<bool>` | Saves a string. |
| `getString(key)` | `String?` | Retrieves a string. |
| `saveInt(key, val)` | `Future<bool>` | Saves an int. |
| `getInt(key)` | `int?` | Retrieves an int. |
| `saveDouble(key, val)` | `Future<bool>` | Saves a double. |
| `getDouble(key)` | `double?` | Retrieves a double. |
| `saveBool(key, val)` | `Future<bool>` | Saves a bool. |
| `getBool(key)` | `bool?` | Retrieves a bool. |
| `saveStringList(key, val)` | `Future<bool>` | Saves a list of strings. |
| `getStringList(key)` | `List<String>?` | Retrieves a list of strings. |
| `saveDateTime(key, val)` | `Future<bool>` | Saves an ISO-8601 DateTime. |
| `getDateTime(key)` | `DateTime?` | Retrieves a DateTime. |
| `saveJson(key, map)` | `Future<bool>` | Saves a JSON map. |
| `getJson(key)` | `Map<String, dynamic>?` | Retrieves and decodes a JSON map. |
| `incrementOrInitInt(key)` | `Future<int>` | Increments or initializes an integer. |
| `decrementInt(key)` | `Future<int>` | Decrements an integer. |
| `toggleBool(key)` | `Future<bool>` | Toggles a boolean. |
| `addToStringList(key, val)` | `Future<bool>` | Appends a unique item to string list. |
| `removeFromStringList(key, val)` | `Future<bool>` | Removes an item from string list. |
| `updateOrAppendToStringList(key, list)` | `Future<bool>` | Merges unique items into string list. |
| `saveBulk(map)` | `Future<void>` | Saves multiple key-value pairs. |
| `getBulk(keys)` | `Map<String, dynamic>` | Retrieves values for multiple keys. |
| `removeBulk(keys)` | `Future<void>` | Removes multiple keys. |
| `retrieveAndRemove(keys)` | `Future<Map<String, dynamic>>` | Retrieves values and deletes their keys. |
| `resetToDefaults(map)` | `Future<void>` | Sets keys to provided default values. |
| `getAll()` | `Map<String, dynamic>` | Returns all stored key-value pairs. |
| `getKeys()` | `Set<String>` | Returns all stored keys. |
| `getKeysByPrefix(prefix)` | `Set<String>` | Returns all keys starting with prefix. |
| `getItemCount()` | `int` | Returns count of stored keys. |
| `containsKey(key)` | `bool` | Checks if a key exists. |
| `remove(key)` | `Future<bool>` | Removes a key. |
| `clear()` | `Future<bool>` | Clears all stored data. |

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

- **Author:** Ali Ben Jahlan
- **Email:** alibenjhlan@gmail.com
- **GitHub:** [ALI-tech-tech](https://github.com/ALI-tech-tech)
