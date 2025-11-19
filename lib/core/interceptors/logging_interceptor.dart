import 'package:dio/dio.dart';

/// Interceptor para logging de peticiones y respuestas
class LoggingInterceptor extends Interceptor {
  final bool logRequest;
  final bool logResponse;
  final bool logError;

  LoggingInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequest) {
      print('═══════════════════════════════════════════════════════════════');
      print('📤 REQUEST [${options.method}] => ${options.uri}');
      print('Headers: ${options.headers}');
      if (options.queryParameters.isNotEmpty) {
        print('Query Parameters: ${options.queryParameters}');
      }
      if (options.data != null) {
        print('Body: ${options.data}');
      }
      print('═══════════════════════════════════════════════════════════════');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponse) {
      print('═══════════════════════════════════════════════════════════════');
      print('📥 RESPONSE [${response.statusCode}] <= ${response.requestOptions.uri}');
      print('Data: ${response.data}');
      print('═══════════════════════════════════════════════════════════════');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError) {
      print('═══════════════════════════════════════════════════════════════');
      print('❌ ERROR [${err.response?.statusCode}] <= ${err.requestOptions.uri}');
      print('Type: ${err.type}');
      print('Message: ${err.message}');
      if (err.response != null) {
        print('Response Data: ${err.response?.data}');
      }
      print('═══════════════════════════════════════════════════════════════');
    }
    super.onError(err, handler);
  }
}
