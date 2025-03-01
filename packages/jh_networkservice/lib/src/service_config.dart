import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Configuration for NetworkService.
class NetworkConfig {
  final String baseUrl;
  final String? method;
  final Duration? connectTimeout;
  final Duration? receiveTimeout;
  final Duration? sendTimeout;
  final Map<String, String>? defaultHeaders;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? extra;
  final bool preserveHeaderCase;
  final ResponseType responseType;
  final String? contentType;
  final bool Function(int?)? validateStatus;
  final bool receiveDataWhenStatusError;
  final bool followRedirects;
  final int maxRedirects;
  final bool persistentConnection;
  final FutureOr<List<int>> Function(String, RequestOptions)? requestEncoder;
  final FutureOr<String?> Function(List<int>, RequestOptions, ResponseBody)?
      responseDecoder;
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
}
