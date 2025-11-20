import 'package:dio/dio.dart';
import 'custom_exception.dart';
import 'exception_type.dart';

extension CustomExceptionFactories on CustomException {

  static CustomException fromDioException(
    Exception error, {
    List<String> messageKeys = const ['message', 'error', 'msg', 'detail'],
  }) {
    try {
      if (error is DioException) {
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        final headers = error.response?.headers.map;
        final requestPath = error.requestOptions.path;
        final requestMethod = error.requestOptions.method;
        final stackTrace = error.stackTrace;

        // Intentar extraer mensaje usando las claves personalizadas
        String? extractedMessage;
        if (responseData is Map<String, dynamic>) {
          for (final key in messageKeys) {
            final value = responseData[key];
            if (value != null && value is String && value.isNotEmpty) {
              extractedMessage = value;
              break;
            }
          }
        }

        // Si no se extrajo mensaje del response, usar mensaje genérico indicando el problema
        final message = extractedMessage ?? 'Error HTTP $statusCode';

        // Manejo específico por código HTTP
        if (statusCode != null) {
          switch (statusCode) {
            case 401:
              return CustomException(
                exceptionType: ExceptionType.unauthorizedException,
                statusCode: statusCode,
                message: message,
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
                message: message,
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
                message: message,
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
                message: message,
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
                message: message,
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
                message: message,
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
              message: message,
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
              message: message,
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
              message: message,
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
              message: message,
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
              message: message,
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
              message: message,
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
              message: message,
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
              message: message,
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

  static CustomException fromParsingException(
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
}
