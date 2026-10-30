import '../models/error_model.dart';

/// Exception thrown when a network or server request fails.
class ServerException implements Exception {
  /// Structured error information.
  final ErrorModel errorModel;

  const ServerException({required this.errorModel});

  @override
  String toString() =>
      'ServerException(statusCode: ${errorModel.statusCode}, message: "${errorModel.message}", error: "${errorModel.error}")';
}
