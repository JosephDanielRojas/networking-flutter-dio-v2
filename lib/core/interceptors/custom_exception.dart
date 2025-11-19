import 'package:dio/dio.dart';

/// Excepción personalizada para manejo de errores HTTP
///
/// Proporciona información detallada sobre errores de red y API
class CustomException implements Exception {
  CustomException({
    required this.message,
    this.code,
    int? statusCode,
    this.exceptionType = ExceptionType.apiException,
    this.responseData,
    this.headers,
    this.requestPath,
    this.requestMethod,
    this.stackTrace,
  })  : statusCode = statusCode ?? 500,
        name = exceptionType.name;

  factory CustomException.fromDioException(Exception error) {
    try {
      if (error is DioException) {
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        final headers = error.response?.headers.map;
        final requestPath = error.requestOptions.path;
        final requestMethod = error.requestOptions.method;
        final stackTrace = error.stackTrace;

        // Intentar extraer mensaje de diferentes estructuras de API
        String? extractedMessage;
        if (responseData is Map<String, dynamic>) {
          extractedMessage = responseData['message'] as String? ??
              responseData['error'] as String? ??
              responseData['msg'] as String?;
        }

        // Manejo específico por código HTTP
        if (statusCode != null) {
          switch (statusCode) {
            case 401:
              return CustomException(
                exceptionType: ExceptionType.unauthorizedException,
                statusCode: statusCode,
                message: extractedMessage ?? 'No autorizado. Por favor, inicie sesión.',
                responseData: responseData,
                headers: headers,
                requestPath: requestPath,
                requestMethod: requestMethod,
                stackTrace: stackTrace,
              );
            case 403:
              return CustomException(
                exceptionType: ExceptionType.forbiddenException,
                statusCode: statusCode,
                message: extractedMessage ?? 'No tiene permisos para acceder a este recurso.',
                responseData: responseData,
                headers: headers,
                requestPath: requestPath,
                requestMethod: requestMethod,
                stackTrace: stackTrace,
              );
            case 404:
              return CustomException(
                exceptionType: ExceptionType.notFoundException,
                statusCode: statusCode,
                message: extractedMessage ?? 'Recurso no encontrado.',
                responseData: responseData,
                headers: headers,
                requestPath: requestPath,
                requestMethod: requestMethod,
                stackTrace: stackTrace,
              );
            case 422:
              return CustomException(
                exceptionType: ExceptionType.validationException,
                statusCode: statusCode,
                message: extractedMessage ?? 'Error de validación en los datos enviados.',
                responseData: responseData,
                headers: headers,
                requestPath: requestPath,
                requestMethod: requestMethod,
                stackTrace: stackTrace,
              );
            case 429:
              return CustomException(
                exceptionType: ExceptionType.tooManyRequestsException,
                statusCode: statusCode,
                message: extractedMessage ?? 'Demasiadas solicitudes. Por favor, intente más tarde.',
                responseData: responseData,
                headers: headers,
                requestPath: requestPath,
                requestMethod: requestMethod,
                stackTrace: stackTrace,
              );
            case >= 500:
              return CustomException(
                exceptionType: ExceptionType.serverException,
                statusCode: statusCode,
                message: extractedMessage ?? 'Error del servidor. Por favor, intente más tarde.',
                responseData: responseData,
                headers: headers,
                requestPath: requestPath,
                requestMethod: requestMethod,
                stackTrace: stackTrace,
              );
          }
        }

        // Manejo por tipo de excepción Dio
        switch (error.type) {
          case DioExceptionType.cancel:
            return CustomException(
              exceptionType: ExceptionType.cancelException,
              statusCode: statusCode,
              message: extractedMessage ?? 'Solicitud cancelada prematuramente',
              responseData: responseData,
              headers: headers,
              requestPath: requestPath,
              requestMethod: requestMethod,
              stackTrace: stackTrace,
            );
          case DioExceptionType.connectionTimeout:
            return CustomException(
              exceptionType: ExceptionType.connectTimeoutException,
              statusCode: statusCode,
              message: extractedMessage ??
                  'No se pudo establecer la conexión. Por favor, verifique su conexión a Internet.',
              responseData: responseData,
              headers: headers,
              requestPath: requestPath,
              requestMethod: requestMethod,
              stackTrace: stackTrace,
            );
          case DioExceptionType.sendTimeout:
            return CustomException(
              exceptionType: ExceptionType.sendTimeoutException,
              statusCode: statusCode,
              message: extractedMessage ?? 'Error al enviar la solicitud',
              responseData: responseData,
              headers: headers,
              requestPath: requestPath,
              requestMethod: requestMethod,
              stackTrace: stackTrace,
            );
          case DioExceptionType.receiveTimeout:
            return CustomException(
              exceptionType: ExceptionType.receiveTimeoutException,
              statusCode: statusCode,
              message: extractedMessage ?? 'Error al recibir la respuesta',
              responseData: responseData,
              headers: headers,
              requestPath: requestPath,
              requestMethod: requestMethod,
              stackTrace: stackTrace,
            );
          case DioExceptionType.badResponse:
            return CustomException(
              exceptionType: ExceptionType.badResponse,
              statusCode: statusCode,
              message: extractedMessage ?? 'Se produjo un error al procesar la solicitud',
              responseData: responseData,
              headers: headers,
              requestPath: requestPath,
              requestMethod: requestMethod,
              stackTrace: stackTrace,
            );
          case DioExceptionType.unknown:
            return CustomException(
              exceptionType: ExceptionType.unrecognizedException,
              statusCode: statusCode,
              message: extractedMessage ?? 'Ocurrió un error desconocido',
              responseData: responseData,
              headers: headers,
              requestPath: requestPath,
              requestMethod: requestMethod,
              stackTrace: stackTrace,
            );
          case DioExceptionType.badCertificate:
            return CustomException(
              exceptionType: ExceptionType.badCertificateException,
              statusCode: statusCode,
              message: extractedMessage ?? 'Problema con el certificado de seguridad',
              responseData: responseData,
              headers: headers,
              requestPath: requestPath,
              requestMethod: requestMethod,
              stackTrace: stackTrace,
            );
          case DioExceptionType.connectionError:
            return CustomException(
              exceptionType: ExceptionType.connectionError,
              statusCode: statusCode,
              message: extractedMessage ??
                  'Error de conexión. Por favor, verifique su conexión a Internet.',
              responseData: responseData,
              headers: headers,
              requestPath: requestPath,
              requestMethod: requestMethod,
              stackTrace: stackTrace,
            );
        }
      }
      if (error is FormatException) {
        return CustomException(
          exceptionType: ExceptionType.formatException,
          message: 'Problemas en obtener los datos',
        );
      } else {
        return CustomException(
          exceptionType: ExceptionType.unrecognizedException,
          message: 'Ocurrió un error desconocido',
        );
      }
    } on FormatException catch (e) {
      return CustomException(
        exceptionType: ExceptionType.formatException,
        message: e.message,
      );
    } on Exception catch (_) {
      return CustomException(
        exceptionType: ExceptionType.unrecognizedException,
        message: 'Ocurrió un error desconocido',
      );
    }
  }

  factory CustomException.fromParsingException(
    FormatException error, {
    bool debugMode = false,
  }) {
    return CustomException(
      exceptionType: ExceptionType.serializationException,
      message: debugMode
          ? error.message
          : 'Se produjo un error al analizar la respuesta',
    );
  }

  final String name;
  final String message;
  final String? code;
  final int? statusCode;
  final ExceptionType exceptionType;
  final dynamic responseData;
  final Map<String, List<String>>? headers;
  final String? requestPath;
  final String? requestMethod;
  final StackTrace? stackTrace;

  // Helper methods para clasificación de errores

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

  @override
  String toString() {
    final buffer = StringBuffer('CustomException: $message');
    if (statusCode != null) {
      buffer.write(' [Status: $statusCode]');
    }
    if (requestMethod != null && requestPath != null) {
      buffer.write(' [$requestMethod $requestPath]');
    }
    buffer.write(' (Type: ${exceptionType.name})');
    return buffer.toString();
  }

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

enum ExceptionType {
  // Errores de autenticación/autorización
  tokenExpiredException,
  unauthorizedException,
  forbiddenException,

  // Errores de conexión/red
  connectionError,
  connectTimeoutException,
  sendTimeoutException,
  receiveTimeoutException,
  socketException,

  // Errores HTTP
  badResponse,
  notFoundException,
  validationException,
  tooManyRequestsException,
  serverException,
  badCertificateException,

  // Errores de datos
  formatException,
  serializationException,
  fetchDataException,

  // Otros errores
  cancelException,
  unrecognizedException,
  apiException,
}
