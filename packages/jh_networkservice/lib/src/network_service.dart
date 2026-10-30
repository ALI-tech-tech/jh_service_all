import 'package:dio/dio.dart';

import 'exceptions/handle_dio_exceptions.dart';
import 'service_config.dart';

/// A configurable network service utilizing [Dio] to manage HTTP requests.
class NetworkService {
  /// The network configuration for this service.
  final NetworkConfig config;

  late final Dio _dio;

  /// Creates a [NetworkService] configured with [config].
  ///
  /// You may optionally provide an existing [dio] instance (e.g. for testing)
  /// and a list of [interceptors].
  NetworkService({
    required this.config,
    Dio? dio,
    List<Interceptor>? interceptors,
  }) {
    _dio = dio ?? Dio(config.toBaseOptions());
    if (interceptors != null && interceptors.isNotEmpty) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  /// The underlying [Dio] instance for advanced configuration.
  Dio get dio => _dio;

  /// Adds a custom interceptor to the Dio client.
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// Retained for backward compatibility. The service is initialized on creation.
  Future<void> init() async {}

  /// Executes a GET request.
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  /// Executes a POST request.
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool isFormData = false,
  }) async {
    try {
      final payload = (isFormData && data is Map<String, dynamic>)
          ? FormData.fromMap(data)
          : data;

      final response = await _dio.post(
        path,
        data: payload,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  /// Executes a PUT request.
  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool isFormData = false,
  }) async {
    try {
      final payload = (isFormData && data is Map<String, dynamic>)
          ? FormData.fromMap(data)
          : data;

      final response = await _dio.put(
        path,
        data: payload,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  /// Executes a PATCH request.
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool isFormData = false,
  }) async {
    try {
      final payload = (isFormData && data is Map<String, dynamic>)
          ? FormData.fromMap(data)
          : data;

      final response = await _dio.patch(
        path,
        data: payload,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  /// Executes a DELETE request.
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool isFormData = false,
  }) async {
    try {
      final payload = (isFormData && data is Map<String, dynamic>)
          ? FormData.fromMap(data)
          : data;

      final response = await _dio.delete(
        path,
        data: payload,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  /// Executes a generic HTTP request for any custom method.
  Future<dynamic> request(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }
}
