// lib/src/services/network_service.dart

import 'package:dio/dio.dart';
import 'package:jh_networkservice/src/exceptions/exceptions.dart';
import 'package:jh_networkservice/src/service_config.dart';


class NetworkService  {
  final NetworkConfig config;
  late Dio _dio;

  NetworkService({required this.config}){
    init();
  }

 
  Future<void> init() async {
    _dio = Dio(config.toBaseOptions());

    // Optionally, add interceptors here
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Modify request if needed
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Modify response if needed
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Handle errors globally
          return handler.next(e);
        },
      ),
    );
  }

  Future<dynamic> delete(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false}) async {
    try {
      final response = await _dio.delete(path,
          data: isFormData ? FormData.fromMap(data) : data,
          queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  Future<dynamic> get(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response =
          await _dio.get(path, data: data, queryParameters: queryParameters);

      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  Future<dynamic> patch(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false}) async {
    try {
      final response = await _dio.patch(path,
          data: isFormData ? FormData.fromMap(data) : data,
          queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  Future<dynamic> post(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false}) async {
    try {
      final response = await _dio.post(path,
          data: isFormData ? FormData.fromMap(data) : data,
          queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }
}
