# jh_networkservice

[![pub package](https://img.shields.io/pub/v/jh_networkservice.svg)](https://pub.dev/packages/jh_networkservice)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A lightweight, configurable Flutter networking service powered by [Dio](https://pub.dev/packages/dio). Designed to handle multiple base URLs, structured error parsing, request cancellation, and interceptors with ease.

---

## Features

- **Multiple Base URLs:** Manage multiple API base URLs with separate configurations cleanly.
- **Complete HTTP Verbs:** Straightforward `get`, `post`, `put`, `patch`, `delete`, and generic `request` methods.
- **Robust Error Handling:** Automatically maps [DioException] to domain [ServerException] containing a structured [ErrorModel].
- **Flexible Configuration:** Set timeouts, default headers, response types, redirect rules, and query parameters via [NetworkConfig].
- **Full Dio Power:** Access the underlying Dio client, inject custom interceptors, use cancel tokens, and listen to progress callbacks.

---

## Installation

Add `jh_networkservice` to your `pubspec.yaml`:

```yaml
dependencies:
  jh_networkservice: ^1.0.0
```

Then install dependencies:

```bash
flutter pub get
```

---

## Quick Start

### 1. Configure Services for Multiple Base URLs

```dart
import 'package:jh_networkservice/jh_networkservice.dart';

class ApiService {
  static final mainService = NetworkService(
    config: NetworkConfig(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 5),
      defaultHeaders: {'Authorization': 'Bearer YOUR_TOKEN'},
    ),
  );

  static final paymentService = NetworkService(
    config: NetworkConfig(
      baseUrl: 'https://payments.example.com',
      connectTimeout: const Duration(seconds: 15),
    ),
  );
}
```

### 2. Perform Network Requests

```dart
// GET Request
try {
  final data = await ApiService.mainService.get('/users/1');
  print('User: $data');
} on ServerException catch (e) {
  print('Failed with status: ${e.errorModel.statusCode}');
  print('Message: ${e.errorModel.message}');
}

// POST Request
final createdUser = await ApiService.mainService.post(
  '/users',
  data: {'name': 'John Doe', 'email': 'john@example.com'},
);

// PUT Request
final updatedUser = await ApiService.mainService.put(
  '/users/1',
  data: {'name': 'Jane Doe'},
);

// DELETE Request
await ApiService.mainService.delete('/users/1');
```

### 3. Error Handling

All network failures are wrapped in a [ServerException]:

```dart
try {
  await ApiService.mainService.get('/profile');
} on ServerException catch (e) {
  final ErrorModel error = e.errorModel;
  print('Status Code: ${error.statusCode}');
  print('User Message: ${error.message}');
  print('Technical Details: ${error.error}');
  print('Raw Response Data: ${error.rawData}');
}
```

### 4. Custom Interceptors & Cancellation

```dart
import 'package:dio/dio.dart';

final service = NetworkService(
  config: NetworkConfig(baseUrl: 'https://api.example.com'),
);

// Add logging or auth refresh interceptors
service.addInterceptor(LogInterceptor(responseBody: true));

// Cancel requests when a widget disposes
final cancelToken = CancelToken();
final response = await service.get('/search', cancelToken: cancelToken);

// Cancel anytime:
cancelToken.cancel('User navigated away');
```

---

## API Summary

| Class | Description |
|---|---|
| `NetworkConfig` | Configuration settings (base URL, timeouts, headers, redirects). |
| `NetworkService` | Client providing `get`, `post`, `put`, `patch`, `delete`, and `request`. |
| `ServerException` | Standard exception thrown on failure. |
| `ErrorModel` | Parsed error structure (`message`, `error`, `statusCode`, `rawData`). |

---

## License

This package is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Author

- **Author:** Ali Ben Jahlan
- **Email:** alibenjhlan@gmail.com
- **GitHub:** [ALI-tech-tech](https://github.com/ALI-tech-tech)
