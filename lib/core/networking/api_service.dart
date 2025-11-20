import 'package:dio/dio.dart';
import '../helper/typedefs.dart';
import '../interceptors/custom_exception.dart';
import '../interceptors/custom_exception_factories.dart';
import 'api_interface.dart';
import 'dio_service.dart';

class ApiService implements ApiInterface {
  ApiService(
    DioService dioService, {
    List<String> messageKeys = const ['message', 'error', 'msg', 'detail'],
  })  : _dioService = dioService,
        _messageKeys = messageKeys;

  final DioService _dioService;
  final List<String> _messageKeys;

  @override
  Future<T> deleteData<T>({
    required String endpoint,
    required T Function(Response<dynamic> response) converter,
    Object? data,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
  }) async {
    try {
      final response = await _dioService.dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );

      return converter(response);
    } on DioException catch (ex) {
      throw CustomExceptionFactories.fromDioException(ex, messageKeys: _messageKeys);
    } catch (ex) {
      throw CustomExceptionFactories.fromDioException(Exception(ex), messageKeys: _messageKeys);
    }
  }

  @override
  Future<List<T>> getCollectionData<T>({
    required String endpoint,
    required List<T> Function(Response<dynamic> response) converter,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
  }) async {
    try {
      final response = await _dioService.dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );

      return converter(response);
    } on DioException catch (ex) {
      throw CustomExceptionFactories.fromDioException(ex, messageKeys: _messageKeys);
    } catch (ex) {
      throw CustomExceptionFactories.fromDioException(Exception(ex), messageKeys: _messageKeys);
    }
  }

  @override
  Future<T> getDocumentData<T>({
    required String endpoint,
    required T Function(Response<dynamic> response) converter,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
  }) async {
    try {
      final response = await _dioService.dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );

      return converter(response);
    } on DioException catch (ex) {
      throw CustomExceptionFactories.fromDioException(ex, messageKeys: _messageKeys);
    } catch (ex) {
      throw CustomExceptionFactories.fromDioException(Exception(ex), messageKeys: _messageKeys);
    }
  }

  @override
  Future<T> postData<T>({
    required String endpoint,
    required T Function(Response<dynamic> response) converter,
    Object? data,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
    void Function(int count, int total)? onSendProgress,
  }) async {
    try {
      final response = await _dioService.dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
        onSendProgress: onSendProgress,
        options: Options(
          headers: headers,
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );

      return converter(response);
    } on DioException catch (ex) {
      throw CustomExceptionFactories.fromDioException(ex, messageKeys: _messageKeys);
    } catch (ex) {
      throw CustomExceptionFactories.fromDioException(Exception(ex), messageKeys: _messageKeys);
    }
  }

  @override
  Future<T> putData<T>({
    required String endpoint,
    required T Function(Response<dynamic> response) converter,
    Object? data,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
  }) async {
    try {
      final response = await _dioService.dio.put(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );

      return converter(response);
    } on DioException catch (ex) {
      throw CustomExceptionFactories.fromDioException(ex, messageKeys: _messageKeys);
    } catch (ex) {
      throw CustomExceptionFactories.fromDioException(Exception(ex), messageKeys: _messageKeys);
    }
  }

  @override
  Future<T> patchData<T>({
    required String endpoint,
    required T Function(Response<dynamic> response) converter,
    Object? data,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
  }) async {
    try {
      final response = await _dioService.dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );

      return converter(response);
    } on DioException catch (ex) {
      throw CustomExceptionFactories.fromDioException(ex, messageKeys: _messageKeys);
    } catch (ex) {
      throw CustomExceptionFactories.fromDioException(Exception(ex), messageKeys: _messageKeys);
    }
  }
}
