import 'package:dio/dio.dart';

import '../models/error_model.dart';
import 'server_exception.dart';

/// Translates a [DioException] into a domain [ServerException].
///
/// Always throws a [ServerException] containing structured [ErrorModel] details.
Never handleDioExceptions(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException(
        errorModel: ErrorModel(
          message: e.message ?? 'Connection timeout with server.',
          error: e.error?.toString() ?? 'ConnectionTimeout',
          statusCode: 408,
          rawData: e.response?.data,
        ),
      );

    case DioExceptionType.sendTimeout:
      throw ServerException(
        errorModel: ErrorModel(
          message: e.message ?? 'Send timeout in connection with server.',
          error: e.error?.toString() ?? 'SendTimeout',
          statusCode: 504,
          rawData: e.response?.data,
        ),
      );

    case DioExceptionType.receiveTimeout:
      throw ServerException(
        errorModel: ErrorModel(
          message: e.message ?? 'Receive timeout in connection with server.',
          error: e.error?.toString() ?? 'ReceiveTimeout',
          statusCode: 504,
          rawData: e.response?.data,
        ),
      );

    case DioExceptionType.badCertificate:
      throw ServerException(
        errorModel: ErrorModel(
          message: e.message ?? 'Invalid or untrusted SSL certificate.',
          error: e.error?.toString() ?? 'BadCertificate',
          statusCode: 495,
          rawData: e.response?.data,
        ),
      );

    case DioExceptionType.cancel:
      throw ServerException(
        errorModel: ErrorModel(
          message: e.message ?? 'Request was cancelled.',
          error: e.error?.toString() ?? 'RequestCancelled',
          statusCode: 499,
          rawData: e.response?.data,
        ),
      );

    case DioExceptionType.connectionError:
      throw ServerException(
        errorModel: ErrorModel(
          message: e.message ??
              'Failed to connect to the server. Check your network connection.',
          error: e.error?.toString() ?? 'ConnectionError',
          statusCode: 503,
          rawData: e.response?.data,
        ),
      );

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode ?? 500;
      final responseData = e.response?.data;
      throw ServerException(
        errorModel: ErrorModel.fromJson(responseData, statusCode: statusCode),
      );

    case DioExceptionType.unknown:
    default:
      throw ServerException(
        errorModel: ErrorModel(
          message: e.message ?? 'An unexpected network error occurred.',
          error: e.error?.toString() ?? 'UnknownError',
          statusCode: 520,
          rawData: e.response?.data,
        ),
      );
  }
}
