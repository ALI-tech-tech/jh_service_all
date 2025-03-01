import 'package:flutter/material.dart';
import 'package:jh_networkservice/jh_networkservice.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// App Configuration with Multiple Base URLs
class AppConfig {
  static const String apiUrl1 = "https://jsonplaceholder.typicode.com";
  static const String apiUrl2 = "https://dummyjson.com";

  static NetworkService getService(String baseUrl) {
    return NetworkService(config: NetworkConfig(baseUrl: baseUrl));
  }
}

/// API Endpoints
class ApiEndpoints {
  static const String getPost = "/posts/1"; // JSONPlaceholder
  static const String getProduct = "/products/1"; // DummyJSON
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? jsonPlaceholderData;
  String? dummyJsonData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchApiData();
  }

  Future<void> _fetchApiData() async {
    try {
      // Fetch data from JSONPlaceholder
      final jsonResponse =
          await AppConfig.getService(AppConfig.apiUrl1).get(ApiEndpoints.getPost);
      jsonPlaceholderData = jsonResponse['title'];

      // Fetch data from DummyJSON
      final dummyResponse =
          await AppConfig.getService(AppConfig.apiUrl2).get(ApiEndpoints.getProduct);
      dummyJsonData = dummyResponse['title'];

    } on ServerException catch (e) {
      jsonPlaceholderData = e.errorModel.message;
      dummyJsonData = e.errorModel.message;
    }

    await Future.delayed(const Duration(seconds: 1)); // Simulating network delay
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('jh_networckservice', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCard("JSONPlaceholder Data", jsonPlaceholderData),
              const SizedBox(height: 20),
              _buildCard("DummyJSON Data", dummyJsonData),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String? data) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          isLoading
              ? const CircularProgressIndicator(color: Colors.blueAccent)
              : Text(
                  data ?? "No data available",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
        ],
      ),
    );
  }
}
