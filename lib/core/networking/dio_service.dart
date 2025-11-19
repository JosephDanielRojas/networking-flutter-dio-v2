import 'package:dio/dio.dart';

/// Servicio base de Dio
///
/// Wrapper simple que proporciona acceso a la instancia de Dio configurada
/// con interceptores y adaptadores personalizados
class DioService {
  DioService({
    required Dio dioClient,
    Iterable<Interceptor>? interceptors,
    HttpClientAdapter? httpClientAdapter,
  }) : _dio = dioClient {
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
    if (httpClientAdapter != null) {
      _dio.httpClientAdapter = httpClientAdapter;
    }
  }

  final Dio _dio;

  /// Getter para acceder a la instancia de Dio
  ///
  /// Usa esta instancia directamente o a través de ApiService
  /// para realizar peticiones HTTP con total flexibilidad
  Dio get dio => _dio;
}
