import 'package:flutter/material.dart';
import 'package:jh_sharedprefs/jh_sharedprefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'jh_sharedprefs Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
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

  void _loadData() {
    setState(() {
      _storedString = _prefsService.getString('myStringKey');
      _storedInt = _prefsService.getInt('myIntKey');
      _storedDateTime = _prefsService.getDateTime('myDateTimeKey');
      _storedBool = _prefsService.getBool('myBoolKey');
      _storedStringList = _prefsService.getStringList('myStringListKey');
      _storedJson = _prefsService.getJson('myJsonKey');
    });
  }

  Future<void> _saveData() async {
    await _prefsService.saveString('myStringKey', 'Hello, World!');
    await _prefsService.saveInt('myIntKey', 42);
    await _prefsService.saveDateTime('myDateTimeKey', DateTime.now());
    await _prefsService.saveBool('myBoolKey', true);
    await _prefsService.saveStringList('myStringListKey', ['apple', 'banana']);
    await _prefsService.saveJson('myJsonKey', {'name': 'John', 'age': 30});
    _loadData();
  }

  Future<void> _clearData() async {
    await _prefsService.clear();
    _loadData();
  }

  Future<void> _toggleBool() async {
    await _prefsService.toggleBool('myBoolKey');
    _loadData();
  }

  Future<void> _addToStringList() async {
    await _prefsService.addToStringList('myStringListKey', 'orange');
    _loadData();
  }

  Future<void> _removeFromStringList() async {
    await _prefsService.removeFromStringList('myStringListKey', 'banana');
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('jh_sharedprefs Example'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stored String: ${_storedString ?? "none"}'),
                    const SizedBox(height: 8),
                    Text('Stored Int: ${_storedInt ?? "none"}'),
                    const SizedBox(height: 8),
                    Text('Stored DateTime: ${_storedDateTime ?? "none"}'),
                    const SizedBox(height: 8),
                    Text('Stored Bool: ${_storedBool ?? "none"}'),
                    const SizedBox(height: 8),
                    Text(
                        'Stored List: ${_storedStringList?.join(", ") ?? "none"}'),
                    const SizedBox(height: 8),
                    Text('Stored JSON: ${_storedJson ?? "none"}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              onPressed: _saveData,
              label: const Text('Save Sample Data'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.toggle_on),
              onPressed: _toggleBool,
              label: const Text('Toggle Bool'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: _addToStringList,
              label: const Text('Add "orange" to List'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.remove),
              onPressed: _removeFromStringList,
              label: const Text('Remove "banana" from List'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearData,
              label: const Text('Clear All Data'),
            ),
          ],
        ),
      ),
    );
  }
}
