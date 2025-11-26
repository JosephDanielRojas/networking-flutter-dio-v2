
abstract class ApiClientInterface {
  const ApiClientInterface();

  /// Realiza una petición GET
  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuthToken = true,
  });

  /// Realiza una petición POST
  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuthToken = true,
    void Function(int count, int total)? onSendProgress,
  });

  /// Realiza una petición PUT
  Future<T> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuthToken = true,
  });

  /// Realiza una petición PATCH
  Future<T> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuthToken = true,
  });

  /// Realiza una petición DELETE
  Future<T> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuthToken = true,
  });
}
