import 'package:dio/dio.dart';
import '../interceptors/custom_exception.dart';
import '../interceptors/custom_exception_factories.dart';

/// Cliente HTTP simple que utiliza Dio
///
/// Retorna Response<dynamic> directo de Dio - sin estructuras predefinidas
class ApiClient {
  final Dio _dio;
  final List<String> _messageKeys;

  ApiClient({
    required String baseUrl,
    Map<String, dynamic>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    List<Interceptor>? interceptors,
    List<String> messageKeys = const ['message', 'error', 'msg', 'detail'],
  })  : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: headers ?? {'Content-Type': 'application/json'},
            connectTimeout: connectTimeout ?? const Duration(seconds: 30),
            receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
          ),
        ),
        _messageKeys = messageKeys {
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  /// Constructor que permite inyectar una instancia de Dio (útil para testing)
  ApiClient.fromDio(
    this._dio, {
    List<String> messageKeys = const ['message', 'error', 'msg', 'detail'],
  }) : _messageKeys = messageKeys;

  /// Getter para acceder a la instancia de Dio
  Dio get dio => _dio;

  /// Getter para obtener la baseUrl actual
  String get baseUrl => _dio.options.baseUrl;

  /// Getter para obtener los headers actuales
  Map<String, dynamic> get headers => _dio.options.headers;

  /// Setter para cambiar la baseUrl
  set baseUrl(String url) => _dio.options.baseUrl = url;

  /// Setter para cambiar los headers (reemplaza todos)
  set headers(Map<String, dynamic> newHeaders) =>
      _dio.options.headers = newHeaders;

  /// Agrega o actualiza un header específico
  void setHeader(String key, dynamic value) {
    _dio.options.headers[key] = value;
  }

  /// Elimina un header específico
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  /// Actualiza múltiples headers (merge con los existentes)
  void updateHeaders(Map<String, dynamic> newHeaders) {
    _dio.options.headers.addAll(newHeaders);
  }

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
      throw CustomExceptionFactories.fromDioException(e, messageKeys: _messageKeys);
    } catch (e) {
      throw CustomExceptionFactories.fromDioException(Exception(e), messageKeys: _messageKeys);
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
      throw CustomExceptionFactories.fromDioException(e, messageKeys: _messageKeys);
    } catch (e) {
      throw CustomExceptionFactories.fromDioException(Exception(e), messageKeys: _messageKeys);
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
      throw CustomExceptionFactories.fromDioException(e, messageKeys: _messageKeys);
    } catch (e) {
      throw CustomExceptionFactories.fromDioException(Exception(e), messageKeys: _messageKeys);
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
      throw CustomExceptionFactories.fromDioException(e, messageKeys: _messageKeys);
    } catch (e) {
      throw CustomExceptionFactories.fromDioException(Exception(e), messageKeys: _messageKeys);
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
      throw CustomExceptionFactories.fromDioException(e, messageKeys: _messageKeys);
    } catch (e) {
      throw CustomExceptionFactories.fromDioException(Exception(e), messageKeys: _messageKeys);
    }
  }
}
