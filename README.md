# jh_service_all

A collection of essential, high-quality Flutter utility packages maintained by [Ali Ben Jahlan](https://github.com/ALI-tech-tech).

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

---

## Packages in this Repository

| Package | Version | Description | pub.dev |
|---|---|---|---|
| [`jh_networkservice`](packages/jh_networkservice) | `1.1.0` | Configurable multi-base-URL network service built on Dio with structured exception handling. | [![pub package](https://img.shields.io/pub/v/jh_networkservice.svg)](https://pub.dev/packages/jh_networkservice) |
| [`jh_sharedprefs`](packages/jh_sharedprefs) | `1.1.0` | Comprehensive persistent storage wrapper for SharedPreferences with JSON, DateTime, and bulk operations. | [![pub package](https://img.shields.io/pub/v/jh_sharedprefs.svg)](https://pub.dev/packages/jh_sharedprefs) |

---

## 1. jh_networkservice

A modular network client for Flutter apps that interact with one or more REST APIs.

- **Features**: Multi-base URLs, full HTTP verbs (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`), automatic error translation to `ServerException` with `ErrorModel`, request cancellation (`CancelToken`), and interceptor support.
- **Directory**: `packages/jh_networkservice`
- **Documentation**: [jh_networkservice README](packages/jh_networkservice/README.md)

---

## 2. jh_sharedprefs

A complete utility service for persistent key-value storage.

- **Features**: Basic primitive types, ISO-8601 `DateTime`, JSON map serialization, unique list manipulation, counter/bool helpers (`incrementOrInitInt`, `toggleBool`), and bulk utilities (`saveBulk`, `retrieveAndRemove`).
- **Directory**: `packages/jh_sharedprefs`
- **Documentation**: [jh_sharedprefs README](packages/jh_sharedprefs/README.md)

---

## Development & Testing

Run tests across packages:

```bash
# Test jh_networkservice
cd packages/jh_networkservice
flutter test

# Test jh_sharedprefs
cd ../jh_sharedprefs
flutter test
```

---

## License

This repository is licensed under the [MIT License](LICENSE).
