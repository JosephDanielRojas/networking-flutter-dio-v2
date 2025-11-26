import 'package:dio/dio.dart';
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

/// Ejemplo ejecutable para demostrar el uso de messageKeys personalizados
///
/// Para ejecutar:
/// dart run example/test_custom_message_keys.dart
void main() async {
  print('═══════════════════════════════════════════════════════════');
  print('   DEMO: messageKeys Personalizados en CustomException');
  print('═══════════════════════════════════════════════════════════\n');

  // ============================================================
  // EJEMPLO 1: API con campo "message" (por defecto)
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 1: API estándar con campo "message"            │');
  print('└─────────────────────────────────────────────────────────┘\n');

  final dio1 = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
  final apiClient1 = ApiClient(DioService(dioClient: dio1));
  // messageKeys por defecto: ['message', 'error', 'msg', 'detail']

  try {
    print('➤ Intentando acceder a un recurso inexistente...\n');
    await apiClient1.get<Map<String, dynamic>>(endpoint: '/posts/99999');
  } on CustomException catch (e) {
    print('✓ Error capturado:');
    print('  Mensaje extraído: ${e.message}');
    print('  Status Code: ${e.statusCode}');
    print('  Response Data: ${e.responseData}\n');
  }

  // ============================================================
  // EJEMPLO 2: API personalizada con campo "errorMessage"
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 2: API con campo personalizado "errorMessage"  │');
  print('└─────────────────────────────────────────────────────────┘\n');

  print('Supongamos que tu API retorna errores así:');
  print('  {');
  print('    "errorMessage": "Usuario no encontrado",');
  print('    "errorCode": "USER_NOT_FOUND",');
  print('    "statusCode": 404');
  print('  }\n');

  final dio2 = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
  final apiClient2 = ApiClient(
    DioService(dioClient: dio2),
    messageKeys: ['errorMessage', 'errorDesc', 'message'], // ← Personalizado
  );

  print('messageKeys configurados: ["errorMessage", "errorDesc", "message"]');
  print('CustomException buscará el mensaje en ese orden.\n');

  // ============================================================
  // EJEMPLO 3: API con múltiples formatos posibles
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 3: API con múltiples formatos de error         │');
  print('└─────────────────────────────────────────────────────────┘\n');

  print('Algunas APIs pueden retornar diferentes formatos:');
  print('  Formato 1: {"error": "Invalid token"}');
  print('  Formato 2: {"message": "User not found"}');
  print('  Formato 3: {"errorDescription": "Permission denied"}');
  print('  Formato 4: {"detail": "Resource unavailable"}\n');

  final dio3 = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
  final apiClient3 = ApiClient(
    DioService(dioClient: dio3),
    messageKeys: [
      'errorDescription', // Buscar primero aquí
      'error',            // Luego aquí
      'message',          // Luego aquí
      'detail',           // Finalmente aquí
    ],
  );

  print('messageKeys configurados:');
  print('  ["errorDescription", "error", "message", "detail"]');
  print('CustomException buscará en orden hasta encontrar un valor.\n');

  // ============================================================
  // EJEMPLO 4: ApiService con messageKeys personalizados
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 4: ApiService con messageKeys personalizados   │');
  print('└─────────────────────────────────────────────────────────┘\n');

  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
  final dioService = DioService(dioClient: dio);

  final apiService = ApiService(
    dioService,
    messageKeys: ['apiError', 'errorMsg', 'message'], // ← Personalizado
  );

  print('ApiService configurado con messageKeys personalizados:');
  print('  ["apiError", "errorMsg", "message"]\n');

  // ============================================================
  // EJEMPLO 5: Comparación de configuraciones
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ RESUMEN: Diferentes configuraciones                    │');
  print('└─────────────────────────────────────────────────────────┘\n');

  print('Configuración por defecto:');
  print('  messageKeys: ["message", "error", "msg", "detail"]');
  print('  Funciona con la mayoría de APIs estándar\n');

  print('Configuración personalizada (Backend propio):');
  print('  messageKeys: ["errorMessage", "error"]');
  print('  Optimizado para tu API específica\n');

  print('Configuración multi-API:');
  print('  messageKeys: ["errorDescription", "error", "message", "detail"]');
  print('  Compatible con múltiples backends diferentes\n');

  // ============================================================
  // EJEMPLO 6: Caso real - API que usa "description"
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 6: Caso Real - Respuesta de error              │');
  print('└─────────────────────────────────────────────────────────┘\n');

  print('Respuesta real de tu API:');
  print('  {');
  print('    "status": "error",');
  print('    "description": "El usuario ya existe en el sistema",');
  print('    "code": 409');
  print('  }\n');

  final dio4 = Dio(BaseOptions(baseUrl: 'https://mi-api.com'));
  final apiClient4 = ApiClient(
    DioService(dioClient: dio4),
    messageKeys: ['description', 'message'], // ← "description" primero
  );

  print('Con messageKeys: ["description", "message"]');
  print('CustomException extraerá: "El usuario ya existe en el sistema"\n');

  print('Sin personalizar messageKeys:');
  print('CustomException extraería: "No autorizado..." (mensaje por defecto)');
  print('porque no encontraría "message", "error", "msg" ni "detail"\n');

  // ============================================================
  // VENTAJAS
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ VENTAJAS de messageKeys Personalizados                 │');
  print('└─────────────────────────────────────────────────────────┘\n');

  print('✓ Adaptable a cualquier estructura de API');
  print('✓ Soporte para múltiples backends simultáneamente');
  print('✓ Mensajes de error más precisos y útiles');
  print('✓ Fallback automático si un campo no existe');
  print('✓ Compatible con APIs legacy y modernas\n');

  print('═══════════════════════════════════════════════════════════');
  print('   FIN DE LA DEMO');
  print('═══════════════════════════════════════════════════════════\n');
}
