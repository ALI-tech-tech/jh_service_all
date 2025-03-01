class ErrorModel {
  String message;
  String error;
  int statusCode;

  ErrorModel(
      {required this.message, required this.error, required this.statusCode});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
        message: json['message'],
        error: json['error'],
        statusCode: json['statusCode']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['error'] = error;
    data['statusCode'] = statusCode;
    return data;
  }
}
