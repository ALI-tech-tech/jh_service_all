import 'package:dio/dio.dart';

import '../models/error_model.dart';
import 'server_exception.dart';

void handleDioExceptions(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException(
          errorModel: ErrorModel(
              message: e.message!,
              error: e.error.toString(),
              statusCode: 408)); // 408: Request Timeout

    case DioExceptionType.sendTimeout:
      throw ServerException(
          errorModel: ErrorModel(
              message: e.message!,
              error: e.error.toString(),
              statusCode: 504)); // 504: Gateway Timeout (sending data failed)

    case DioExceptionType.receiveTimeout:
      throw ServerException(
          errorModel: ErrorModel(
              message: e.message!,
              error: e.error.toString(),
              statusCode: 504)); // 504: Gateway Timeout (receiving data failed)

    case DioExceptionType.badCertificate:
      throw ServerException(
          errorModel: ErrorModel(
              message: e.message!,
              error: e.error.toString(),
              statusCode: 495)); // 495: SSL Certificate Error

    case DioExceptionType.cancel:
      throw ServerException(
          errorModel: ErrorModel(
              message: e.message!,
              error: e.error.toString(),
              statusCode: 499)); // 499: Client Closed Request (canceled)

    case DioExceptionType.connectionError:
      throw ServerException(
          errorModel: ErrorModel(
              message: e.message!,
              error: e.error.toString(),
              statusCode: 503)); // 503: Service Unavailable (connection failed)

    case DioExceptionType.unknown:
      throw ServerException(
          errorModel: ErrorModel(
              message: e.message!,
              error: e.error.toString(),
              statusCode: 520)); // 520: Unknown Error (catch-all for unknown)

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: //Bad request
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 401: //unauthorized
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 403: //forbidden
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 404: //not found
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 409: //coffcient
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 422: //Unprocessable Entity
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 504: //server exeption
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
      }
  }
}
