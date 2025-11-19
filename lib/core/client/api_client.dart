import 'package:dio/dio.dart';
import '../interceptors/custom_exception.dart';

/// Cliente HTTP simple que utiliza Dio
///
/// Retorna Response<dynamic> directo de Dio - sin estructuras predefinidas
class ApiClient {
  final Dio _dio;

  ApiClient({
    required String baseUrl,
    Map<String, dynamic>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    List<Interceptor>? interceptors,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: headers ?? {'Content-Type': 'application/json'},
            connectTimeout: connectTimeout ?? const Duration(seconds: 30),
            receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
          ),
        ) {
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  /// Constructor que permite inyectar una instancia de Dio (útil para testing)
  ApiClient.fromDio(this._dio);

  /// Getter para acceder a la instancia de Dio
  Dio get dio => _dio;

  /// Método GET - Retorna Response<dynamic> de Dio
  Future<Response<dynamic>> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    } catch (e) {
      throw CustomException.fromDioException(Exception(e));
    }
  }

  /// Método POST - Retorna Response<dynamic> de Dio
  Future<Response<dynamic>> post({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    } catch (e) {
      throw CustomException.fromDioException(Exception(e));
    }
  }

  /// Método PUT - Retorna Response<dynamic> de Dio
  Future<Response<dynamic>> put({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    } catch (e) {
      throw CustomException.fromDioException(Exception(e));
    }
  }

  /// Método PATCH - Retorna Response<dynamic> de Dio
  Future<Response<dynamic>> patch({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    } catch (e) {
      throw CustomException.fromDioException(Exception(e));
    }
  }

  /// Método DELETE - Retorna Response<dynamic> de Dio
  Future<Response<dynamic>> delete({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    } catch (e) {
      throw CustomException.fromDioException(Exception(e));
    }
  }
}
