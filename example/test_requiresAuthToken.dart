import 'package:dio/dio.dart';
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

/// Ejemplo ejecutable para demostrar el uso de requiresAuthToken
///
/// Para ejecutar:
/// dart run example/test_requiresAuthToken.dart
void main() async {
  print('═══════════════════════════════════════════════════════════');
  print('   DEMO: requiresAuthToken con extra parameter');
  print('═══════════════════════════════════════════════════════════\n');

  // ============================================================
  // Setup: Crear ApiService con AuthInterceptor
  // ============================================================
  final dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  ));

  dio.interceptors.addAll([
    AuthInterceptor(token: 'mi_token_secreto_123', logAuthHeaders: false),
    LoggingInterceptor(
      logRequest: true,
      logResponse: true,
      logError: true,
    ),
  ]);

  final apiService = ApiService(DioService(dioClient: dio));

  // ============================================================
  // EJEMPLO 1: requiresAuthToken = true (por defecto)
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 1: requiresAuthToken = true (CON token)        │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    print('➤ Llamando a /posts/1 con requiresAuthToken = true\n');

    await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/posts/1',
      converter: (response) => response.data as Map<String, dynamic>,
      requiresAuthToken: true, // ← Añadirá el header Authorization
    );

    print('\n✓ Observa que el header "Authorization: Bearer mi_token_secreto_123" FUE añadido\n');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 2: requiresAuthToken = false (SIN token)
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 2: requiresAuthToken = false (SIN token)       │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    print('➤ Llamando a /posts/2 con requiresAuthToken = false\n');

    await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/posts/2',
      converter: (response) => response.data as Map<String, dynamic>,
      requiresAuthToken: false, // ← NO añadirá el header Authorization
    );

    print('\n✓ Observa que el header "Authorization" NO fue añadido\n');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 3: POST con requiresAuthToken = true
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 3: POST con requiresAuthToken = true           │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    print('➤ Creando un post con autenticación\n');

    await apiService.postData<Map<String, dynamic>>(
      endpoint: '/posts',
      data: {
        'title': 'Nuevo Post Autenticado',
        'body': 'Este post requiere autenticación',
        'userId': 1,
      },
      converter: (response) => response.data as Map<String, dynamic>,
      requiresAuthToken: true, // ← Añadirá el token
    );

    print('\n✓ El token fue añadido al POST\n');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 4: POST con requiresAuthToken = false
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 4: POST con requiresAuthToken = false          │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    print('➤ Creando un post sin autenticación (público)\n');

    await apiService.postData<Map<String, dynamic>>(
      endpoint: '/posts',
      data: {
        'title': 'Post Público',
        'body': 'Este post NO requiere autenticación',
        'userId': 1,
      },
      converter: (response) => response.data as Map<String, dynamic>,
      requiresAuthToken: false, // ← NO añadirá el token
    );

    print('\n✓ El token NO fue añadido al POST\n');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 5: Comparación lado a lado
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ RESUMEN: Diferencias en los headers                    │');
  print('└─────────────────────────────────────────────────────────┘\n');

  print('requiresAuthToken: true  → Headers: {Authorization: Bearer ...}');
  print('requiresAuthToken: false → Headers: {} (sin Authorization)\n');

  print('═══════════════════════════════════════════════════════════');
  print('   FIN DE LA DEMO');
  print('═══════════════════════════════════════════════════════════\n');
}
