import 'package:dio/dio.dart';
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

/// Ejemplo de uso de ResponseExtensions
///
/// Demuestra cómo los helpers simplifican la extracción de datos
/// de diferentes estructuras de respuesta
void main() async {
  final dio = Dio(
    BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'),
  );

  dio.interceptors.add(LoggingInterceptor());

  final apiService = ApiService(DioService(dioClient: dio));

  print('═══════════════════════════════════════════════════════════');
  print('   DEMO: ResponseExtensions Helper Methods');
  print('═══════════════════════════════════════════════════════════\n');

  // ============================================================
  // EJEMPLO 1: getCollection() - Array directo
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 1: getCollection() con array directo           │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    // API que retorna: [{...}, {...}, {...}]
    final users = await apiService.getCollectionData<Map<String, dynamic>>(
      endpoint: '/users',
      converter: (response) {
        // Antes (sin extensions):
        // final list = response.data as List;
        // return list.map((item) => item as Map<String, dynamic>).toList();

        // Ahora (con extensions):
        return response
            .getCollection()
            .map((item) => item as Map<String, dynamic>)
            .toList();
      },
      queryParams: {'_limit': 3},
      requiresAuthToken: false,
    );

    print('✓ Usuarios obtenidos: ${users.length}');
    for (var user in users) {
      print('  - ${user['name']}');
    }
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 2: getCollection() - Array anidado
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 2: getCollection() con array anidado           │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    // Simular API que retorna: {"data": [{...}], "total": 10}
    final posts = await apiService.getCollectionData<Map<String, dynamic>>(
      endpoint: '/posts',
      converter: (response) {
        // Antes (sin extensions):
        // final wrapper = response.data as Map<String, dynamic>;
        // final list = wrapper['data'] as List;
        // return list.map((item) => item as Map<String, dynamic>).toList();

        // Ahora (con extensions):
        // Si el array está en 'data', 'items', 'results' o 'list', lo encuentra automáticamente
        return response
            .getCollection(possibleKeys: ['posts', 'data', 'items'])
            .map((item) => item as Map<String, dynamic>)
            .toList();
      },
      queryParams: {'_limit': 3},
      requiresAuthToken: false,
    );

    print('✓ Posts obtenidos: ${posts.length}');
    for (var post in posts) {
      print('  - ${post['title']}');
    }
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 3: getDocument() - Objeto directo
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 3: getDocument() con objeto directo            │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    // API que retorna: {"id": 1, "name": "..."}
    final user = await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/users/1',
      converter: (response) {
        // Antes (sin extensions):
        // return response.data as Map<String, dynamic>;

        // Ahora (con extensions):
        return response.getDocument() ?? {};
      },
      requiresAuthToken: false,
    );

    print('✓ Usuario: ${user['name']}');
    print('  Email: ${user['email']}');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 4: getValue() - Extraer valores específicos
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 4: getValue() para extraer valores             │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    final posts = await apiService.getCollectionData<Map<String, dynamic>>(
      endpoint: '/posts',
      converter: (response) {
        // Extraer valores específicos de la metadata
        final total = response.getValue<int>('total', defaultValue: 0);
        final page = response.getValue<int>('page', defaultValue: 1);

        print('  Metadata extraída:');
        print('    Total: $total');
        print('    Página: $page\n');

        return response
            .getCollection()
            .map((item) => item as Map<String, dynamic>)
            .toList();
      },
      queryParams: {'_limit': 5},
      requiresAuthToken: false,
    );

    print('✓ Posts procesados: ${posts.length}');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 5: hasKey() - Verificar existencia de claves
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 5: hasKey() para validar estructura            │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/users/1',
      converter: (response) {
        // Verificar si la respuesta tiene ciertas claves
        print('  Verificación de estructura:');
        print('    ¿Tiene "id"?: ${response.hasKey('id')}');
        print('    ¿Tiene "error"?: ${response.hasKey('error')}');
        print('    ¿Tiene "data"?: ${response.hasKey('data')}');

        return response.getDocument() ?? {};
      },
      requiresAuthToken: false,
    );

    print('\n✓ Validación completada');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 6: getMetadata() - Extraer información de paginación
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 6: getMetadata() para paginación               │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    await apiService.getCollectionData<Map<String, dynamic>>(
      endpoint: '/posts',
      converter: (response) {
        // Extraer metadata de paginación
        final meta = response.getMetadata(keys: ['pagination', 'meta', 'info']);

        if (meta != null) {
          print('  Información de paginación:');
          print('    Total: ${meta['total']}');
          print('    Página actual: ${meta['page']}');
          print('    Por página: ${meta['perPage']}');
        } else {
          print('  No hay metadata de paginación disponible');
        }

        return response
            .getCollection()
            .map((item) => item as Map<String, dynamic>)
            .toList();
      },
      queryParams: {'_limit': 5},
      requiresAuthToken: false,
    );

    print('\n✓ Paginación procesada');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  // ============================================================
  // EJEMPLO 7: Uso combinado - Caso real complejo
  // ============================================================
  print('\n┌─────────────────────────────────────────────────────────┐');
  print('│ EJEMPLO 7: Uso combinado de múltiples helpers          │');
  print('└─────────────────────────────────────────────────────────┘\n');

  try {
    final result = await apiService.getCollectionData<Map<String, dynamic>>(
      endpoint: '/posts',
      converter: (response) {
        // 1. Verificar si hay error
        if (response.hasKey('error')) {
          final errorMsg = response.getValue<String>('error');
          throw Exception('API Error: $errorMsg');
        }

        // 2. Extraer metadata
        final meta = response.getMetadata();
        if (meta != null) {
          print('  Metadata encontrada: ${meta.keys}');
        }

        // 3. Extraer la colección con múltiples claves posibles
        final items = response.getCollection(
          possibleKeys: ['posts', 'data', 'items', 'results'],
        );

        print('  Items encontrados: ${items.length}');

        // 4. Procesar items
        return items.map((item) => item as Map<String, dynamic>).toList();
      },
      queryParams: {'_limit': 3},
      requiresAuthToken: false,
    );

    print('\n✓ Procesamiento complejo completado');
    print('  Total de resultados: ${result.length}');
  } on CustomException catch (e) {
    print('✗ Error: ${e.message}');
  }

  print('\n═══════════════════════════════════════════════════════════');
  print('   FIN DEL DEMO');
  print('═══════════════════════════════════════════════════════════');
}
