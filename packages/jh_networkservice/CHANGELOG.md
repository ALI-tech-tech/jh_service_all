## 1.1.0

* Added `put` HTTP method and support for per-request `Options`, `CancelToken`, and progress callbacks.
* Fixed non-exhaustive `DioExceptionType` pattern matching (including `transformTimeout`).
* Enhanced `ErrorModel` with resilient parsing across map, string, and status code fallbacks.
* Added `addInterceptor` and getter for the underlying `Dio` instance.
* Added comprehensive unit test suite (24 tests).
* Modernized dependencies to the latest stable versions.

## 1.0.0

* Initial release of `jh_networkservice`.
