import 'package:dio/dio.dart';
import '../helper/typedefs.dart';
import '../interceptors/custom_exception.dart';
import 'api_interface.dart';
import 'dio_service.dart';

/// Servicio de API completamente flexible
///
/// Trabaja directamente con Response de Dio - el usuario tiene control total
/// sobre cómo parsear requests y responses
class ApiService implements ApiInterface {
  ApiService(DioService dioService) : _dioService = dioService;

  final DioService _dioService;

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
      throw CustomException.fromDioException(ex);
    } catch (ex) {
      throw CustomException.fromDioException(Exception(ex));
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
      throw CustomException.fromDioException(ex);
    } catch (ex) {
      throw CustomException.fromDioException(Exception(ex));
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
      throw CustomException.fromDioException(ex);
    } catch (ex) {
      throw CustomException.fromDioException(Exception(ex));
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
      throw CustomException.fromDioException(ex);
    } catch (ex) {
      throw CustomException.fromDioException(Exception(ex));
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
      throw CustomException.fromDioException(ex);
    } catch (ex) {
      throw CustomException.fromDioException(Exception(ex));
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
      throw CustomException.fromDioException(ex);
    } catch (ex) {
      throw CustomException.fromDioException(Exception(ex));
    }
  }
}
