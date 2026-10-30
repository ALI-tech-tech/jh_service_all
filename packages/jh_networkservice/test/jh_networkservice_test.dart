import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jh_networkservice/jh_networkservice.dart';

void main() {
  group('ErrorModel Tests', () {
    test('constructs with given parameters', () {
      const model = ErrorModel(
        message: 'Something went wrong',
        error: 'GenericError',
        statusCode: 400,
      );

      expect(model.message, 'Something went wrong');
      expect(model.error, 'GenericError');
      expect(model.statusCode, 400);
      expect(
        model.toString(),
        'ErrorModel(statusCode: 400, message: Something went wrong, error: GenericError)',
      );
    });

    test('fromJson parses map with standard keys', () {
      final json = {
        'message': 'Invalid input',
        'error': 'ValidationError',
        'statusCode': 422,
      };

      final model = ErrorModel.fromJson(json);
      expect(model.message, 'Invalid input');
      expect(model.error, 'ValidationError');
      expect(model.statusCode, 422);
    });

    test('fromJson parses alternative keys (msg, detail, status, code)', () {
      final json = {
        'detail': 'Resource not found',
        'code': 404,
      };

      final model = ErrorModel.fromJson(json, statusCode: 404);
      expect(model.message, 'Resource not found');
      expect(model.statusCode, 404);
    });

    test('fromJson handles string payloads gracefully', () {
      const rawText = '502 Bad Gateway';
      final model = ErrorModel.fromJson(rawText, statusCode: 502);

      expect(model.message, rawText);
      expect(model.error, rawText);
      expect(model.statusCode, 502);
      expect(model.rawData, rawText);
    });

    test('fromJson handles null or unexpected payloads', () {
      final model = ErrorModel.fromJson(null, statusCode: 500);

      expect(model.message, 'Unexpected server response');
      expect(model.statusCode, 500);
    });

    test('toJson and copyWith work as expected', () {
      const model = ErrorModel(
        message: 'Original',
        error: 'Err',
        statusCode: 500,
      );

      final json = model.toJson();
      expect(json['message'], 'Original');
      expect(json['statusCode'], 500);

      final updated = model.copyWith(message: 'Updated');
      expect(updated.message, 'Updated');
      expect(updated.statusCode, 500);
      expect(model == model.copyWith(), isTrue);
    });
  });

  group('NetworkConfig Tests', () {
    test('converts config to Dio BaseOptions properly', () {
      final config = NetworkConfig(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 8),
        defaultHeaders: {'Authorization': 'Bearer test'},
      );

      final options = config.toBaseOptions();
      expect(options.baseUrl, 'https://api.example.com');
      expect(options.connectTimeout, const Duration(seconds: 8));
      expect(options.headers['Authorization'], 'Bearer test');
    });

    test('copyWith updates config fields', () {
      final config = NetworkConfig(baseUrl: 'https://api.example.com');
      final updated = config.copyWith(baseUrl: 'https://other.example.com');

      expect(updated.baseUrl, 'https://other.example.com');
      expect(config.baseUrl, 'https://api.example.com');
    });
  });

  group('handleDioExceptions Tests', () {
    test('handles connectionTimeout', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionTimeout,
        message: 'Timeout connecting',
      );

      expect(
        () => handleDioExceptions(dioException),
        throwsA(
          isA<ServerException>().having(
            (e) => e.errorModel.statusCode,
            'statusCode',
            408,
          ),
        ),
      );
    });

    test('handles sendTimeout', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.sendTimeout,
      );

      expect(
        () => handleDioExceptions(dioException),
        throwsA(
          isA<ServerException>().having(
            (e) => e.errorModel.statusCode,
            'statusCode',
            504,
          ),
        ),
      );
    });

    test('handles receiveTimeout', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.receiveTimeout,
      );

      expect(
        () => handleDioExceptions(dioException),
        throwsA(
          isA<ServerException>().having(
            (e) => e.errorModel.statusCode,
            'statusCode',
            504,
          ),
        ),
      );
    });

    test('handles badCertificate', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badCertificate,
      );

      expect(
        () => handleDioExceptions(dioException),
        throwsA(
          isA<ServerException>().having(
            (e) => e.errorModel.statusCode,
            'statusCode',
            495,
          ),
        ),
      );
    });

    test('handles cancel', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.cancel,
      );

      expect(
        () => handleDioExceptions(dioException),
        throwsA(
          isA<ServerException>().having(
            (e) => e.errorModel.statusCode,
            'statusCode',
            499,
          ),
        ),
      );
    });

    test('handles connectionError', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      );

      expect(
        () => handleDioExceptions(dioException),
        throwsA(
          isA<ServerException>().having(
            (e) => e.errorModel.statusCode,
            'statusCode',
            503,
          ),
        ),
      );
    });

    test('handles badResponse with map data', () {
      final requestOptions = RequestOptions(path: '/');
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 404,
          data: {
            'message': 'User not found',
            'error': 'NotFound',
            'statusCode': 404,
          },
        ),
      );

      expect(
        () => handleDioExceptions(dioException),
        throwsA(
          isA<ServerException>()
              .having((e) => e.errorModel.statusCode, 'statusCode', 404)
              .having((e) => e.errorModel.message, 'message', 'User not found'),
        ),
      );
    });

    test('handles unknown and fallback types', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.unknown,
      );

      expect(
        () => handleDioExceptions(dioException),
        throwsA(
          isA<ServerException>().having(
            (e) => e.errorModel.statusCode,
            'statusCode',
            520,
          ),
        ),
      );
    });
  });

  group('NetworkService HTTP Operations', () {
    late Dio mockDio;
    late NetworkService service;

    setUp(() {
      final config = NetworkConfig(baseUrl: 'https://api.example.com');
      mockDio = Dio(config.toBaseOptions());

      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/success-get') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'result': 'got data'},
                ),
              );
            } else if (options.path == '/success-post') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 201,
                  data: {'created': options.data},
                ),
              );
            } else if (options.path == '/success-put') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'updated': options.data},
                ),
              );
            } else if (options.path == '/success-patch') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'patched': options.data},
                ),
              );
            } else if (options.path == '/success-delete') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 204,
                  data: {'deleted': true},
                ),
              );
            } else if (options.path == '/error') {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: Response(
                    requestOptions: options,
                    statusCode: 400,
                    data: {'message': 'Bad Request', 'error': 'InvalidParam'},
                  ),
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      service = NetworkService(config: config, dio: mockDio);
    });

    test('GET request returns data', () async {
      final res = await service.get('/success-get');
      expect(res, {'result': 'got data'});
    });

    test('POST request sends data and returns response', () async {
      final res = await service.post('/success-post', data: {'title': 'New'});
      expect(res, {
        'created': {'title': 'New'}
      });
    });

    test('PUT request sends data and returns response', () async {
      final res = await service.put('/success-put', data: {'title': 'Updated'});
      expect(res, {
        'updated': {'title': 'Updated'}
      });
    });

    test('PATCH request sends data and returns response', () async {
      final res =
          await service.patch('/success-patch', data: {'desc': 'Patch'});
      expect(res, {
        'patched': {'desc': 'Patch'}
      });
    });

    test('DELETE request returns response', () async {
      final res = await service.delete('/success-delete');
      expect(res, {'deleted': true});
    });

    test('request() executes custom method', () async {
      final res = await service.request('/success-get');
      expect(res, {'result': 'got data'});
    });

    test('HTTP error throws ServerException', () async {
      expect(
        () async => await service.get('/error'),
        throwsA(
          isA<ServerException>()
              .having((e) => e.errorModel.statusCode, 'statusCode', 400)
              .having((e) => e.errorModel.message, 'message', 'Bad Request'),
        ),
      );
    });

    test('dio getter and addInterceptor work properly', () {
      expect(service.dio, equals(mockDio));
      final testInterceptor = QueuedInterceptorsWrapper();
      service.addInterceptor(testInterceptor);
      expect(service.dio.interceptors.contains(testInterceptor), isTrue);
    });
  });
}
