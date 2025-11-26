import 'package:dio/dio.dart';
import '../interceptors/custom_exception.dart';
import '../interceptors/custom_exception_factories.dart';
import '../networking/dio_service.dart';
import 'api_client_interface.dart';

/// Cliente HTTP simple que utiliza Dio con tipos genéricos
///
/// Retorna directamente el tipo T sin necesidad de converters
class ApiClient implements ApiClientInterface {
  ApiClient(
    DioService dioService, {
    List<String> messageKeys = const ['message', 'error', 'msg', 'detail'],
  })  : _dioService = dioService,
        _messageKeys = messageKeys;

  /// Constructor que permite inyectar una instancia de Dio directamente (útil para testing)
  ApiClient.fromDio(
    Dio dio, {
    List<String> messageKeys = const ['message', 'error', 'msg', 'detail'],
  })  : _dioService = DioService(dioClient: dio),
        _messageKeys = messageKeys;

  final DioService _dioService;
  final List<String> _messageKeys;

  /// Getter para acceder a la instancia de Dio
  Dio get dio => _dioService.dio;

  /// Getter para obtener la baseUrl actual
  String get baseUrl => _dioService.dio.options.baseUrl;

  /// Getter para obtener los headers actuales
  Map<String, dynamic> get headers => _dioService.dio.options.headers;

  /// Setter para cambiar la baseUrl
  set baseUrl(String url) => _dioService.dio.options.baseUrl = url;

  /// Setter para cambiar los headers (reemplaza todos)
  set headers(Map<String, dynamic> newHeaders) =>
      _dioService.dio.options.headers = newHeaders;

  /// Agrega o actualiza un header específico
  void setHeader(String key, dynamic value) {
    _dioService.dio.options.headers[key] = value;
  }

  /// Elimina un header específico
  void removeHeader(String key) {
    _dioService.dio.options.headers.remove(key);
  }

  /// Actualiza múltiples headers (merge con los existentes)
  void updateHeaders(Map<String, dynamic> newHeaders) {
    _dioService.dio.options.headers.addAll(newHeaders);
  }

  @override
  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuthToken = true,
  }) async {
    try {
      final response = await _dioService.dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );

      return response.data as T;
    } on DioException catch (e) {
      throw CustomExceptionFactories.fromDioException(e, messageKeys: _messageKeys);
    } catch (e) {
      throw CustomExceptionFactories.fromDioException(Exception(e), messageKeys: _messageKeys);
    }
  }

  @override
  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuthToken = true,
    void Function(int count, int total)? onSendProgress,
  }) async {
    try {
      final response = await _dioService.dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        options: Options(
          headers: headers,
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );

      return response.data as T;
    } on DioException catch (e) {
      throw CustomExceptionFactories.fromDioException(e, messageKeys: _messageKeys);
    } catch (e) {
      throw CustomExceptionFactories.fromDioException(Exception(e), messageKeys: _messageKeys);
    }
  }

  @override
  Future<T> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuthToken = true,
  }) async {
    try {
      final response = await _dioService.dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );

      return response.data as T;
    } on DioException catch (e) {
      throw CustomExceptionFactories.fromDioException(e, messageKeys: _messageKeys);
    } catch (e) {
      throw CustomExceptionFactories.fromDioException(Exception(e), messageKeys: _messageKeys);
    }
  }

  @override
  Future<T> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuthToken = true,
  }) async {
    try {
      final response = await _dioService.dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );

      return response.data as T;
    } on DioException catch (e) {
      throw CustomExceptionFactories.fromDioException(e, messageKeys: _messageKeys);
    } catch (e) {
      throw CustomExceptionFactories.fromDioException(Exception(e), messageKeys: _messageKeys);
    }
  }

  @override
  Future<T> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuthToken = true,
  }) async {
    try {
      final response = await _dioService.dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );

      return response.data as T;
    } on DioException catch (e) {
      throw CustomExceptionFactories.fromDioException(e, messageKeys: _messageKeys);
    } catch (e) {
      throw CustomExceptionFactories.fromDioException(Exception(e), messageKeys: _messageKeys);
    }
  }
}
