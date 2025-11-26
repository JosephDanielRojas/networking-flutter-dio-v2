import 'package:dio/dio.dart';
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

/// Ejemplo ejecutable para ver los logs de LoggingInterceptor
///
/// Para ejecutar:
/// dart run example/test_logging.dart
void main() async {
  print('═══════════════════════════════════════════════════════════');
  print('   DEMO: LoggingInterceptor en Acción');
  print('═══════════════════════════════════════════════════════════\n');

  // ============================================================
  // EJEMPLO 1: ApiClient con LoggingInterceptor
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 1: ApiClient con LoggingInterceptor            │');
  print('└─────────────────────────────────────────────────────────┘\n');

  final dio1 = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
  dio1.interceptors.add(LoggingInterceptor(
    logRequest: true,   // Mostrar requests
    logResponse: true,  // Mostrar responses
    logError: true,     // Mostrar errores
  ));

  final apiClient = ApiClient(DioService(dioClient: dio1));

  try {
    print('➤ Haciendo GET a /posts/1...\n');
    final post = await apiClient.get<Map<String, dynamic>>(endpoint: '/posts/1');

    print('\n✓ Respuesta recibida:');
    print('  Título: ${post['title']}\n');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 2: POST Request con datos
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 2: POST Request con datos                      │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    print('➤ Haciendo POST a /posts con datos...\n');
    final newPost = await apiClient.post<Map<String, dynamic>>(
      endpoint: '/posts',
      data: {
        'title': 'Ejemplo de Post',
        'body': 'Este es el contenido del post',
        'userId': 1,
      },
    );

    print('\n✓ Post creado:');
    print('  ID: ${newPost['id']}\n');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 3: Request que genera error (404)
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 3: Request con error 404                       │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    print('➤ Haciendo GET a endpoint inexistente...\n');
    await apiClient.get<Map<String, dynamic>>(endpoint: '/posts/99999');
  } on CustomException catch (e) {
    print('\n✓ Error capturado correctamente:');
    print('  Mensaje: ${e.message}');
    print('  Status: ${e.statusCode}');
    print('  Tipo: ${e.exceptionType.name}');
    print('  Es error del cliente: ${e.isClientError}');
    print('  Request: ${e.requestMethod} ${e.requestPath}\n');
  }

  // ============================================================
  // EJEMPLO 4: ApiService con LoggingInterceptor
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 4: ApiService con LoggingInterceptor           │');
  print('└─────────────────────────────────────────────────────────┘\n');

  final dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  ));

  dio.interceptors.add(
    LoggingInterceptor(
      logRequest: true,
      logResponse: true,
      logError: true,
    ),
  );

  final apiService = ApiService(DioService(dioClient: dio));

  try {
    print('➤ Usando ApiService con converter...\n');
    final post = await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/posts/2',
      converter: (response) {
        print('  [Converter] Procesando response con statusCode: ${response.statusCode}');
        return response.data as Map<String, dynamic>;
      },
      requiresAuthToken: false,
    );

    print('\n✓ Datos parseados:');
    print('  Título: ${post['title']}\n');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 5: Con AuthInterceptor + LoggingInterceptor
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 5: Con AuthInterceptor + LoggingInterceptor    │');
  print('└─────────────────────────────────────────────────────────┘\n');

  final dioAuth = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
  dioAuth.interceptors.addAll([
    AuthInterceptor(token: 'mi_token_secreto_123', logAuthHeaders: false),
    LoggingInterceptor(
      logRequest: true,
      logResponse: true,
      logError: true,
    ),
  ]);

  final apiClientAuth = ApiClient(DioService(dioClient: dioAuth));

  try {
    print('➤ Haciendo request con autenticación...\n');
    final post = await apiClientAuth.get<Map<String, dynamic>>(endpoint: '/posts/3');

    print('\n✓ Request autenticado:');
    print('  Título: ${post['title']}');
    print('  (El token fue añadido automáticamente)\n');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  print('═══════════════════════════════════════════════════════════');
  print('   FIN DE LA DEMO');
  print('═══════════════════════════════════════════════════════════\n');
}
