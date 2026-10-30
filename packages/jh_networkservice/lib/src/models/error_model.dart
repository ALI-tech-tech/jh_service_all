/// Represents a standardized error model returned from network requests.
class ErrorModel {
  /// A human-readable message describing the error.
  final String message;

  /// Detailed error string or code.
  final String error;

  /// The HTTP status code associated with the error.
  final int statusCode;

  /// The raw payload received from the server, if any.
  final dynamic rawData;

  const ErrorModel({
    required this.message,
    required this.error,
    required this.statusCode,
    this.rawData,
  });

  /// Factory constructor to safely create an [ErrorModel] from various backend response formats.
  factory ErrorModel.fromJson(dynamic json, {int? statusCode}) {
    final effectiveStatusCode = statusCode ?? 0;

    if (json is Map<String, dynamic>) {
      final msg = json['message'] ??
          json['msg'] ??
          json['detail'] ??
          json['error_description'] ??
          'Unknown error';

      final err = json['error'] ??
          json['errors']?.toString() ??
          json['code']?.toString() ??
          json['status']?.toString() ??
          msg.toString();

      final parsedCode = json['statusCode'] is int
          ? json['statusCode'] as int
          : (json['status'] is int
              ? json['status'] as int
              : (json['code'] is int
                  ? json['code'] as int
                  : effectiveStatusCode));

      return ErrorModel(
        message: msg.toString(),
        error: err.toString(),
        statusCode: parsedCode,
        rawData: json,
      );
    } else if (json is String && json.isNotEmpty) {
      return ErrorModel(
        message: json,
        error: json,
        statusCode: effectiveStatusCode,
        rawData: json,
      );
    }

    return ErrorModel(
      message: 'Unexpected server response',
      error: 'ServerError',
      statusCode: effectiveStatusCode,
      rawData: json,
    );
  }

  /// Converts the [ErrorModel] to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message,
      'error': error,
      'statusCode': statusCode,
      if (rawData != null) 'rawData': rawData,
    };
  }

  /// Creates a copy of this [ErrorModel] with the given fields replaced.
  ErrorModel copyWith({
    String? message,
    String? error,
    int? statusCode,
    dynamic rawData,
  }) {
    return ErrorModel(
      message: message ?? this.message,
      error: error ?? this.error,
      statusCode: statusCode ?? this.statusCode,
      rawData: rawData ?? this.rawData,
    );
  }

  @override
  String toString() {
    return 'ErrorModel(statusCode: $statusCode, message: $message, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ErrorModel &&
        other.message == message &&
        other.error == error &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode => Object.hash(message, error, statusCode);
}
