import 'package:dio/dio.dart';

/// Interceptor para manejar autenticación con tokens
class AuthInterceptor extends Interceptor {
  String? _token;

  AuthInterceptor({String? token, required bool logAuthHeaders}) : _token = token;

  /// Actualiza el token de autenticación
  void updateToken(String? token) {
    _token = token;
  }

  /// Obtiene el token actual
  String? get token => _token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  
    final requiresToken = options.extra['requiresAuthToken'] as bool? ?? true;

    if (requiresToken && _token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    
    if (err.response?.statusCode == 401) {
      print('⚠️ Token expirado o inválido');
    }
    super.onError(err, handler);
  }
}
