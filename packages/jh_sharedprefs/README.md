# `jh_sharedprefs` Package Documentation

The `jh_sharedprefs` package is a utility for managing persistent storage in Flutter applications using the `shared_preferences` package. It provides a simple and efficient way to store, retrieve, update, and delete data in key-value pairs. This package is designed to simplify working with `SharedPreferences` by offering a clean and intuitive API.

---

## Table of Contents

1. [Installation](#installation)
2. [Usage](#usage)
   - [Initialization](#initialization)
   - [Saving Data](#saving-data)
   - [Retrieving Data](#retrieving-data)
   - [Updating Data](#updating-data)
   - [Deleting Data](#deleting-data)
   - [Advanced Features](#advanced-features)
3. [API Reference](#api-reference)
4. [Example](#example)
5. [License](#license)

---

## Installation

Add the `jh_sharedprefs` package to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  jh_sharedprefs: ^1.0.0
```

Then, run `flutter pub get` to install the package.

---

## Usage

### Initialization

Before using the `jh_sharedprefs` package, you must initialize it. This is typically done in the `main` function or in the `initState` of your main widget.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService().init(); // Initialize SharedPreferences
  runApp(MyApp());
}
```

---

### Saving Data

You can save various types of data using the following methods:

- **String**: `saveString`
- **Integer**: `saveInt`
- **Double**: `saveDouble`
- **Boolean**: `saveBool`
- **String List**: `saveStringList`
- **DateTime**: `saveDateTime`
- **JSON Object**: `saveJson`

Example:

```dart
await SharedPrefsService().saveString('myStringKey', 'Hello, World!');
await SharedPrefsService().saveInt('myIntKey', 42);
await SharedPrefsService().saveBool('myBoolKey', true);
await SharedPrefsService().saveStringList('myStringListKey', ['apple', 'banana']);
await SharedPrefsService().saveJson('myJsonKey', {'name': 'John', 'age': 30});
```

---

### Retrieving Data

You can retrieve stored data using the following methods:

- **String**: `getString`
- **Integer**: `getInt`
- **Double**: `getDouble`
- **Boolean**: `getBool`
- **String List**: `getStringList`
- **DateTime**: `getDateTime`
- **JSON Object**: `getJson`

Example:

```dart
String? myString = SharedPrefsService().getString('myStringKey');
int? myInt = SharedPrefsService().getInt('myIntKey');
bool? myBool = SharedPrefsService().getBool('myBoolKey');
List<String>? myList = SharedPrefsService().getStringList('myStringListKey');
Map<String, dynamic>? myJson = SharedPrefsService().getJson('myJsonKey');
```

---

### Updating Data

You can update existing data or append new data using the following methods:

- **Update or Append to String List**: `updateOrAppendToStringList`
- **Increment Integer**: `incrementOrInitInt`
- **Decrement Integer**: `decrementInt`
- **Toggle Boolean**: `toggleBool`
- **Add to String List**: `addToStringList`
- **Remove from String List**: `removeFromStringList`

Example:

```dart
await SharedPrefsService().updateOrAppendToStringList('myStringListKey', ['orange']);
await SharedPrefsService().incrementOrInitInt('myIntKey', incrementBy: 5);
await SharedPrefsService().toggleBool('myBoolKey');
await SharedPrefsService().addToStringList('myStringListKey', 'grape');
await SharedPrefsService().removeFromStringList('myStringListKey', 'banana');
```

---

### Deleting Data

You can delete data using the following methods:

- **Remove a Key**: `remove`
- **Remove Multiple Keys**: `removeBulk`
- **Clear All Data**: `clear`

Example:

```dart
await SharedPrefsService().remove('myStringKey');
await SharedPrefsService().removeBulk(['myIntKey', 'myBoolKey']);
await SharedPrefsService().clear();
```

---

### Advanced Features

- **Bulk Operations**: Save, retrieve, or remove multiple key-value pairs at once.
- **Reset to Defaults**: Reset keys to specified default values.
- **Retrieve All Keys**: Get all stored keys or keys with a specific prefix.
- **Batch Increment Integers**: Increment multiple integer values in one go.
- **Retrieve and Remove**: Retrieve values and remove the keys afterward.

Example:

```dart
await SharedPrefsService().saveBulk({
  'key1': 'value1',
  'key2': 123,
  'key3': true,
});

Map<String, dynamic> bulkData = SharedPrefsService().getBulk(['key1', 'key2', 'key3']);

await SharedPrefsService().resetToDefaults({
  'key1': 'defaultValue',
  'key2': 0,
});

Set<String> keysWithPrefix = SharedPrefsService().getKeysByPrefix('key');

await SharedPrefsService().batchIncrementInts({
  'counter1': 1,
  'counter2': 2,
});

Map<String, dynamic> retrievedData = SharedPrefsService().retrieveAndRemove(['key1', 'key2']);
```

---

## API Reference

### Methods

| Method Name                     | Description                                                                 |
|---------------------------------|-----------------------------------------------------------------------------|
| `init()`                        | Initializes the SharedPreferences instance.                                 |
| `saveString(key, value)`        | Saves a string value.                                                       |
| `getString(key)`                | Retrieves a string value.                                                   |
| `saveDateTime(key, value)`      | Saves a DateTime value as a string.                                         |
| `getDateTime(key)`              | Retrieves a DateTime value.                                                 |
| `updateOrAppendToStringList(key, newList)` | Updates or appends to a string list.                                |
| `saveBulk(data)`                | Saves multiple key-value pairs.                                             |
| `getBulk(keys)`                 | Retrieves multiple values for a list of keys.                               |
| `removeBulk(keys)`              | Removes multiple keys.                                                      |
| `incrementOrInitInt(key, {incrementBy, initialValue})` | Increments or initializes an integer value.                 |
| `decrementInt(key, {decrementBy})` | Decrements an integer value.                                           |
| `toggleBool(key)`               | Toggles a boolean value.                                                    |
| `addToStringList(key, value)`   | Adds a single item to a string list.                                        |
| `removeFromStringList(key, value)` | Removes a single item from a string list.                                |
| `getAll()`                      | Retrieves all key-value pairs.                                              |
| `saveJson(key, json)`           | Saves a JSON object as a string.                                            |
| `getJson(key)`                  | Retrieves a JSON object.                                                    |
| `resetToDefaults(defaultValues)`| Resets keys to specified default values.                                    |
| `getKeysByPrefix(prefix)`       | Retrieves all keys that start with a specified prefix.                      |
| `getItemCount()`                | Returns the number of stored items.                                         |
| `batchIncrementInts(increments)`| Increments multiple integer values.                                         |
| `retrieveAndRemove(keys)`       | Retrieves and removes values for a list of keys.                            |
| `getValue<T>(key)`              | Retrieves a value by type.                                                  |
| `getKeys()`                     | Retrieves all keys.                                                         |
| `clear()`                       | Clears all stored data.                                                     |
| `saveInt(key, value)`           | Saves an integer value.                                                     |
| `getInt(key)`                   | Retrieves an integer value.                                                 |
| `saveDouble(key, value)`        | Saves a double value.                                                       |
| `getDouble(key)`                | Retrieves a double value.                                                   |
| `saveBool(key, value)`          | Saves a boolean value.                                                      |
| `getBool(key)`                  | Retrieves a boolean value.                                                  |
| `saveStringList(key, value)`    | Saves a list of strings.                                                    |
| `getStringList(key)`            | Retrieves a list of strings.                                                |
| `containsKey(key)`              | Checks if a key exists.                                                     |
| `remove(key)`                   | Removes a value for a specific key.                                         |

---

## Example

For a complete example, refer to the [Full Example Code](#full-example-code) provided in the documentation.

---

## License

This package is open-source and available under the MIT License.

---

## Full Example Code

```dart
import 'package:flutter/material.dart';
import 'package:jh_sharedprefs/jh_sharedprefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService().init(); // Initialize SharedPreferences
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jh_sharedprefs Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SharedPrefsService _prefsService = SharedPrefsService();
  String? _storedString;
  int? _storedInt;
  DateTime? _storedDateTime;
  bool? _storedBool;
  List<String>? _storedStringList;
  Map<String, dynamic>? _storedJson;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    setState(() {
      _storedString = _prefsService.getString('myStringKey');
      _storedInt = _prefsService.getInt('myIntKey');
      _storedDateTime = _prefsService.getDateTime('myDateTimeKey');
      _storedBool = _prefsService.getBool('myBoolKey');
      _storedStringList = _prefsService.getStringList('myStringListKey');
      _storedJson = _prefsService.getJson('myJsonKey');
    });
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    await _prefsService.saveString('myStringKey', 'Hello, World!');
    await _prefsService.saveInt('myIntKey', 42);
    await _prefsService.saveDateTime('myDateTimeKey', DateTime.now());
    await _prefsService.saveBool('myBoolKey', true);
    await _prefsService.saveStringList('myStringListKey', ['apple', 'banana']);
    await _prefsService.saveJson('myJsonKey', {'name': 'John', 'age': 30});
    _loadData();
  }

  // Clear all data from SharedPreferences
  Future<void> _clearData() async {
    await _prefsService.clear();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('jh_sharedprefs Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Stored String: $_storedString'),
            Text('Stored Int: $_storedInt'),
            Text('Stored DateTime: $_storedDateTime'),
            Text('Stored Bool: $_storedBool'),
            Text('Stored String List: ${_storedStringList?.join(', ')}'),
            Text('Stored JSON: $_storedJson'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save Data'),
            ),
            ElevatedButton(
              onPressed: _clearData,
              child: Text('Clear Data'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

This package is designed to make working with `SharedPreferences` in Flutter easier and more efficient. Enjoy using `jh_sharedprefs`! 🚀


### Contributing

Contributions are welcome! If you would like to contribute to this package, please fork the repository and submit a pull request. For significant changes, please open an issue first to discuss what you would like to change.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Contact

For any questions or feedback, feel free to reach out:

- **Author:** Ali Ben Jahlan
- **Email:** alibenjhlan@gmail.com
- **GitHub:** [Ali-tech-tech](https://github.com/ALI-tech-tech)