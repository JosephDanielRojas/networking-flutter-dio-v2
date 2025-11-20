import 'exception_type.dart';
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
}
