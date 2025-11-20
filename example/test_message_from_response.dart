import 'package:dio/dio.dart';
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

/// Ejemplo demostrando que el mensaje SIEMPRE viene del response
///
/// Para ejecutar:
/// dart run example/test_message_from_response.dart
void main() async {
  print('═══════════════════════════════════════════════════════════');
  print('   DEMO: Mensaje Obligatorio del Response');
  print('═══════════════════════════════════════════════════════════\n');

  // ============================================================
  // EJEMPLO 1: Response CON mensaje en el campo esperado
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 1: Response con campo "message"                │');
  print('└─────────────────────────────────────────────────────────┘\n');

  final apiClient = ApiClient(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  );

  try {
    print('➤ Intentando acceder a /posts/99999 (no existe)...\n');
    await apiClient.get(endpoint: '/posts/99999');
  } on CustomException catch (e) {
    print('Response del servidor: {}');
    print('messageKeys buscados: [message, error, msg, detail]');
    print('Campo encontrado: ninguno\n');
    print('✓ CustomException.message: "${e.message}"');
    print('  (Como no encontró mensaje, usa: "Error HTTP ${e.statusCode}")\n');
  }

  // ============================================================
  // EJEMPLO 2: Simulación - Response con mensaje
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 2: Response con mensaje del servidor           │');
  print('└─────────────────────────────────────────────────────────┘\n');

  print('Supongamos que el servidor responde:');
  print('  Status: 404');
  print('  Body: {');
  print('    "message": "El usuario con ID 123 no fue encontrado",');
  print('    "code": "USER_NOT_FOUND"');
  print('  }\n');

  print('CustomException extraerá:');
  print('  message: "El usuario con ID 123 no fue encontrado"');
  print('  (Mensaje directo del servidor)\n');

  // ============================================================
  // EJEMPLO 3: Response sin ningún campo de mensaje
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 3: Response SIN campos de mensaje              │');
  print('└─────────────────────────────────────────────────────────┘\n');

  print('Supongamos que el servidor responde:');
  print('  Status: 403');
  print('  Body: {');
  print('    "status": "forbidden",');
  print('    "timestamp": "2024-01-15T10:30:00Z"');
  print('  }\n');

  print('messageKeys buscados: [message, error, msg, detail]');
  print('Ninguno de estos campos existe en el response\n');

  print('CustomException usará:');
  print('  message: "Error HTTP 403"');
  print('  (Mensaje genérico basado en statusCode)\n');

  // ============================================================
  // EJEMPLO 4: Response con campo personalizado
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 4: messageKeys personalizado                   │');
  print('└─────────────────────────────────────────────────────────┘\n');

  final apiClient2 = ApiClient(
    baseUrl: 'https://api.example.com',
    messageKeys: ['errorDescription', 'message'],
  );

  print('messageKeys configurados: [errorDescription, message]\n');

  print('Response del servidor:');
  print('  {');
  print('    "errorDescription": "Token de autenticación inválido o expirado",');
  print('    "errorCode": "AUTH_001"');
  print('  }\n');

  print('CustomException extraerá:');
  print('  message: "Token de autenticación inválido o expirado"');
  print('  (Del campo "errorDescription" configurado)\n');

  // ============================================================
  // COMPARACIÓN: Antes vs Ahora
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ COMPARACIÓN: Antes vs Ahora                            │');
  print('└─────────────────────────────────────────────────────────┘\n');

  print('ANTES (con mensajes por defecto):');
  print('  Response: {"status": "error"}');
  print('  message: "No autorizado. Por favor, inicie sesión."');
  print('  → Mensaje hardcodeado, no del servidor\n');

  print('AHORA (mensaje del response):');
  print('  Response: {"status": "error"}');
  print('  message: "Error HTTP 401"');
  print('  → Mensaje genérico indicando el problema\n');

  print('AHORA (con mensaje en response):');
  print('  Response: {"message": "Sesión expirada"}');
  print('  message: "Sesión expirada"');
  print('  → Mensaje exacto del servidor\n');

  // ============================================================
  // VENTAJAS
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ VENTAJAS del Mensaje Obligatorio del Response          │');
  print('└─────────────────────────────────────────────────────────┘\n');

  print('✓ Mensajes más precisos y útiles del backend');
  print('✓ Consistencia con la respuesta del servidor');
  print('✓ Facilita debugging (ver mensaje exacto del API)');
  print('✓ Permite internacionalización del backend');
  print('✓ No mensajes "inventados" en el cliente\n');

  // ============================================================
  // CASOS DE USO REALES
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ CASOS DE USO REALES                                    │');
  print('└─────────────────────────────────────────────────────────┘\n');

  print('Caso 1 - Error de validación:');
  print('  Response: {"message": "El email ya está registrado"}');
  print('  → Usuario ve exactamente lo que el backend quiere comunicar\n');

  print('Caso 2 - Error de negocio:');
  print('  Response: {"error": "Saldo insuficiente para realizar la transferencia"}');
  print('  → Mensaje claro del dominio de negocio\n');

  print('Caso 3 - Error sin mensaje:');
  print('  Response: {"code": 500}');
  print('  → mensaje: "Error HTTP 500"');
  print('  → Fallback genérico cuando el backend no envía mensaje\n');

  print('═══════════════════════════════════════════════════════════');
  print('   FIN DE LA DEMO');
  print('═══════════════════════════════════════════════════════════\n');
}
