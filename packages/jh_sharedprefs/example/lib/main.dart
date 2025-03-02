import 'package:flutter/material.dart';
import 'package:jh_sharedprefs/jh_sharedprefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService().init(); // Initialize SharedPreferences
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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

  // Toggle a boolean value
  Future<void> _toggleBool() async {
    await _prefsService.toggleBool('myBoolKey');
    _loadData();
  }

  // Add an item to a string list
  Future<void> _addToStringList() async {
    await _prefsService.addToStringList('myStringListKey', 'orange');
    _loadData();
  }

  // Remove an item from a string list
  Future<void> _removeFromStringList() async {
    await _prefsService.removeFromStringList('myStringListKey', 'banana');
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SharedPreferences Example'),
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
            ElevatedButton(
              onPressed: _toggleBool,
              child: Text('Toggle Bool'),
            ),
            ElevatedButton(
              onPressed: _addToStringList,
              child: Text('Add to String List'),
            ),
            ElevatedButton(
              onPressed: _removeFromStringList,
              child: Text('Remove from String List'),
            ),
          ],
        ),
      ),
    );
  }
}
