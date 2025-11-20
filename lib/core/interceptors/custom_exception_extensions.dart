import 'custom_exception.dart';
import 'exception_type.dart';

extension CustomExceptionHelpers on CustomException {
  /// Verifica si es un error del cliente (4xx)
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;

  /// Verifica si es un error del servidor (5xx)
  bool get isServerError =>
      statusCode != null && statusCode! >= 500 && statusCode! < 600;

  /// Verifica si es un error de red/conectividad
  bool get isNetworkError =>
      exceptionType == ExceptionType.connectionError ||
      exceptionType == ExceptionType.connectTimeoutException ||
      exceptionType == ExceptionType.sendTimeoutException ||
      exceptionType == ExceptionType.receiveTimeoutException;

  /// Verifica si es un error de autenticación
  bool get isAuthError =>
      exceptionType == ExceptionType.unauthorizedException ||
      exceptionType == ExceptionType.forbiddenException ||
      exceptionType == ExceptionType.tokenExpiredException;

  /// Convierte la excepción a un mapa para logging o debugging
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'message': message,
      'code': code,
      'statusCode': statusCode,
      'exceptionType': exceptionType.name,
      'requestPath': requestPath,
      'requestMethod': requestMethod,
      'responseData': responseData,
      'headers': headers,
      'isClientError': isClientError,
      'isServerError': isServerError,
      'isNetworkError': isNetworkError,
      'isAuthError': isAuthError,
    };
  }
}
