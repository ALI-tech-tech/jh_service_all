import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Configuration class used to initialize [NetworkService].
class NetworkConfig {
  /// Base URL of the API (e.g. `https://api.example.com`).
  final String baseUrl;

  /// Default HTTP request method (e.g. `GET`, `POST`).
  final String? method;

  /// Timeout duration when initiating a connection.
  final Duration? connectTimeout;

  /// Timeout duration when receiving data from the server.
  final Duration? receiveTimeout;

  /// Timeout duration when sending data to the server.
  final Duration? sendTimeout;

  /// Default HTTP headers included with every request.
  final Map<String, dynamic>? defaultHeaders;

  /// Default query parameters included with every request.
  final Map<String, dynamic>? queryParameters;

  /// Custom extra map passed to Dio request options.
  final Map<String, dynamic>? extra;

  /// Whether to preserve the case of header keys.
  final bool preserveHeaderCase;

  /// Expected response type (default is [ResponseType.json]).
  final ResponseType responseType;

  /// Default content-type for request body.
  final String? contentType;

  /// Custom validation logic for HTTP response status codes.
  final bool Function(int?)? validateStatus;

  /// Whether to receive response payload when status error occurs.
  final bool receiveDataWhenStatusError;

  /// Whether to follow HTTP redirects.
  final bool followRedirects;

  /// Maximum allowed redirects before throwing an error.
  final int maxRedirects;

  /// Whether to maintain persistent TCP connections.
  final bool persistentConnection;

  /// Custom request encoder callback.
  final FutureOr<List<int>> Function(String, RequestOptions)? requestEncoder;

  /// Custom response decoder callback.
  final FutureOr<String?> Function(List<int>, RequestOptions, ResponseBody)?
      responseDecoder;

  /// Format used for collection-like query parameters.
  final ListFormat? listFormat;

  NetworkConfig({
    required this.baseUrl,
    this.method,
    this.connectTimeout = const Duration(milliseconds: 5000),
    this.receiveTimeout = const Duration(milliseconds: 3000),
    this.sendTimeout = kIsWeb ? null : const Duration(milliseconds: 3000),
    this.defaultHeaders,
    this.queryParameters,
    this.extra,
    this.preserveHeaderCase = false,
    this.responseType = ResponseType.json,
    this.contentType,
    this.validateStatus,
    this.receiveDataWhenStatusError = true,
    this.followRedirects = true,
    this.maxRedirects = 5,
    this.persistentConnection = true,
    this.requestEncoder,
    this.responseDecoder,
    this.listFormat,
  });

  /// Converts this [NetworkConfig] to Dio's [BaseOptions].
  BaseOptions toBaseOptions() {
    return BaseOptions(
      baseUrl: baseUrl,
      method: method,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      headers: defaultHeaders,
      contentType: contentType,
      extra: extra,
      followRedirects: followRedirects,
      listFormat: listFormat,
      preserveHeaderCase: preserveHeaderCase,
      responseType: responseType,
      validateStatus: validateStatus,
      receiveDataWhenStatusError: receiveDataWhenStatusError,
      maxRedirects: maxRedirects,
      persistentConnection: persistentConnection,
      requestEncoder: requestEncoder,
      responseDecoder: responseDecoder,
      queryParameters: queryParameters,
    );
  }

  /// Creates a copy of this [NetworkConfig] with specified overrides.
  NetworkConfig copyWith({
    String? baseUrl,
    String? method,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, dynamic>? defaultHeaders,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
    bool? preserveHeaderCase,
    ResponseType? responseType,
    String? contentType,
    bool Function(int?)? validateStatus,
    bool? receiveDataWhenStatusError,
    bool? followRedirects,
    int? maxRedirects,
    bool? persistentConnection,
    FutureOr<List<int>> Function(String, RequestOptions)? requestEncoder,
    FutureOr<String?> Function(List<int>, RequestOptions, ResponseBody)?
        responseDecoder,
    ListFormat? listFormat,
  }) {
    return NetworkConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      method: method ?? this.method,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
      queryParameters: queryParameters ?? this.queryParameters,
      extra: extra ?? this.extra,
      preserveHeaderCase: preserveHeaderCase ?? this.preserveHeaderCase,
      responseType: responseType ?? this.responseType,
      contentType: contentType ?? this.contentType,
      validateStatus: validateStatus ?? this.validateStatus,
      receiveDataWhenStatusError:
          receiveDataWhenStatusError ?? this.receiveDataWhenStatusError,
      followRedirects: followRedirects ?? this.followRedirects,
      maxRedirects: maxRedirects ?? this.maxRedirects,
      persistentConnection: persistentConnection ?? this.persistentConnection,
      requestEncoder: requestEncoder ?? this.requestEncoder,
      responseDecoder: responseDecoder ?? this.responseDecoder,
      listFormat: listFormat ?? this.listFormat,
    );
  }
}
