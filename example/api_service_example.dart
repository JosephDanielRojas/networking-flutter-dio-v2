import 'package:dio/dio.dart';
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

/// Ejemplo de uso de ApiService con Response<dynamic> de Dio
/// Completamente flexible para cualquier tipo de API
void main() async {
  // ============================================
  // Configuración inicial
  // ============================================

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // Agregar interceptores
  dio.interceptors.addAll([
    LoggingInterceptor(),
    AuthInterceptor(token: 'tu_token_aqui', logAuthHeaders: false),
  ]);

  // Crear servicios
  final dioService = DioService(dioClient: dio);
  final apiService = ApiService(dioService);

  // ============================================
  // Ejemplo 1: GET - Respuesta directa (sin wrapper)
  // ============================================

  try {
    final user = await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/users/1',
      converter: (response) {
        // Acceso completo al Response de Dio
        print('Status Code: ${response.statusCode}');
        print('Headers: ${response.headers}');

        // Retornar los datos directamente
        return response.data as Map<String, dynamic>;
      },
      requiresAuthToken: false,
    );

    print('Usuario: ${user['name']}');
  } on CustomException catch (e) {
    print('Error: ${e.message} (${e.statusCode})');
  }

  // ============================================
  // Ejemplo 2: GET - Respuesta con estructura anidada
  // ============================================

  try {
    // API que retorna: { "success": true, "data": {...}, "message": "OK" }
    final user = await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/users/1',
      converter: (response) {
        final wrapper = response.data as Map<String, dynamic>;

        // Verificar success
        if (wrapper['success'] != true) {
          throw Exception(wrapper['message']);
        }

        // Extraer la data anidada
        return wrapper['data'] as Map<String, dynamic>;
      },
      requiresAuthToken: false,
    );

    print('Usuario: ${user['name']}');
  } on CustomException catch (e) {
    print('Error: ${e.message}');
  }

  // ============================================
  // Ejemplo 3: GET Collection - Lista directa
  // ============================================

  try {
    final users = await apiService.getCollectionData<Map<String, dynamic>>(
      endpoint: '/users',
      converter: (response) {
        // API retorna lista directamente: [{"id": 1}, {"id": 2}]
        final list = response.data as List;
        return list.map((item) => item as Map<String, dynamic>).toList();
      },
      queryParams: {'_limit': 5},
      requiresAuthToken: false,
    );

    print('Total de usuarios: ${users.length}');
    for (var user in users) {
      print('- ${user['name']}');
    }
  } on CustomException catch (e) {
    print('Error: ${e.message}');
  }

  // ============================================
  // Ejemplo 4: GET Collection - Lista anidada
  // ============================================

  try {
    // API que retorna: { "data": [...], "total": 10, "page": 1 }
    final users = await apiService.getCollectionData<Map<String, dynamic>>(
      endpoint: '/users',
      converter: (response) {
        final wrapper = response.data as Map<String, dynamic>;
        final list = wrapper['data'] as List;

        print('Total en API: ${wrapper['total']}');
        print('Página: ${wrapper['page']}');

        return list.map((item) => item as Map<String, dynamic>).toList();
      },
      requiresAuthToken: false,
    );

    print('Usuarios obtenidos: ${users.length}');
  } on CustomException catch (e) {
    print('Error: ${e.message}');
  }

  // ============================================
  // Ejemplo 5: POST - Crear recurso
  // ============================================

  try {
    final newPost = await apiService.postData<Map<String, dynamic>>(
      endpoint: '/posts',
      data: {
        'title': 'Mi nuevo post',
        'body': 'Contenido del post',
        'userId': 1,
      },
      converter: (response) {
        print('Status: ${response.statusCode}'); // 201 Created
        return response.data as Map<String, dynamic>;
      },
      requiresAuthToken: false,
    );

    print('Post creado con ID: ${newPost['id']}');
  } on CustomException catch (e) {
    print('Error al crear: ${e.message}');
  }

  // ============================================
  // Ejemplo 6: PUT - Actualizar completo
  // ============================================

  try {
    final updatedPost = await apiService.putData<Map<String, dynamic>>(
      endpoint: '/posts/1',
      data: {
        'id': 1,
        'title': 'Título actualizado',
        'body': 'Cuerpo actualizado',
        'userId': 1,
      },
      converter: (response) => response.data as Map<String, dynamic>,
      requiresAuthToken: false,
    );

    print('Post actualizado: ${updatedPost['title']}');
  } on CustomException catch (e) {
    print('Error al actualizar: ${e.message}');
  }

  // ============================================
  // Ejemplo 7: PATCH - Actualización parcial
  // ============================================

  try {
    final patchedPost = await apiService.patchData<Map<String, dynamic>>(
      endpoint: '/posts/1',
      data: {
        'title': 'Solo actualizar el título',
      },
      converter: (response) => response.data as Map<String, dynamic>,
      requiresAuthToken: false,
    );

    print('Post parcheado: ${patchedPost['title']}');
  } on CustomException catch (e) {
    print('Error al parchear: ${e.message}');
  }

  // ============================================
  // Ejemplo 8: DELETE - Eliminar recurso
  // ============================================

  try {
    final result = await apiService.deleteData<Map<String, dynamic>>(
      endpoint: '/posts/1',
      converter: (response) {
        if (response.statusCode == 200) {
          print('Eliminado exitosamente');
        }
        return response.data as Map<String, dynamic>;
      },
      requiresAuthToken: false,
    );

    print('Resultado: $result');
  } on CustomException catch (e) {
    print('Error al eliminar: ${e.message}');
  }

  // ============================================
  // Ejemplo 9: Convertir a modelos personalizados
  // ============================================

  try {
    final users = await apiService.getCollectionData<User>(
      endpoint: '/users',
      converter: (response) {
        final list = response.data as List;
        return list.map((json) => User.fromJson(json)).toList();
      },
      requiresAuthToken: false,
    );

    print('Usuarios como modelos:');
    for (var user in users) {
      print('- ${user.name} (${user.email})');
    }
  } on CustomException catch (e) {
    print('Error: ${e.message}');
  }

  // ============================================
  // Ejemplo 10: Headers personalizados
  // ============================================

  try {
    final data = await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/posts/1',
      headers: {
        'X-Custom-Header': 'CustomValue',
        'Accept': 'application/json',
      },
      converter: (response) => response.data as Map<String, dynamic>,
      requiresAuthToken: false,
    );

    print('Data con headers personalizados: ${data['title']}');
  } on CustomException catch (e) {
    print('Error: ${e.message}');
  }

  // ============================================
  // Ejemplo 11: Query parameters complejos
  // ============================================

  try {
    final posts = await apiService.getCollectionData<Map<String, dynamic>>(
      endpoint: '/posts',
      queryParams: {
        'userId': 1,
        '_page': 1,
        '_limit': 10,
        '_sort': 'id',
        '_order': 'desc',
      },
      converter: (response) {
        final list = response.data as List;
        return list.map((item) => item as Map<String, dynamic>).toList();
      },
      requiresAuthToken: false,
    );

    print('Posts filtrados: ${posts.length}');
  } on CustomException catch (e) {
    print('Error: ${e.message}');
  }

  // ============================================
  // Ejemplo 12: Manejo de errores por statusCode
  // ============================================

  try {
    final data = await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/users/99999',
      converter: (response) {
        // Validar status code dentro del converter
        if (response.statusCode == 404) {
          throw Exception('Usuario no encontrado');
        }

        if (response.statusCode != 200) {
          throw Exception('Error: ${response.statusCode}');
        }

        return response.data as Map<String, dynamic>;
      },
      requiresAuthToken: false,
    );

    print('Data: $data');
  } on CustomException catch (e) {
    print('Error de API: ${e.message} (${e.statusCode})');

    // Manejo específico por tipo de error
    switch (e.exceptionType) {
      case ExceptionType.connectionError:
        print('Sin conexión a Internet');
        break;
      case ExceptionType.connectTimeoutException:
        print('Timeout de conexión');
        break;
      case ExceptionType.badResponse:
        print('Respuesta inválida del servidor');
        break;
      default:
        print('Error desconocido');
    }
  } catch (e) {
    print('Error inesperado: $e');
  }

  // ============================================
  // Ejemplo 13: Upload con progreso
  // ============================================

  try {
    final result = await apiService.postData<Map<String, dynamic>>(
      endpoint: '/upload',
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile('/path/to/file.pdf'),
        'description': 'Mi archivo',
        'category': 'documents',
      }),
      converter: (response) {
        print('Upload completado con status: ${response.statusCode}');
        return response.data as Map<String, dynamic>;
      },
      onSendProgress: (count, total) {
        final progress = (count / total * 100).toStringAsFixed(2);
        print('Progreso del upload: $progress%');
      },
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    );

    print('Archivo subido: ${result['fileUrl']}');
  } on CustomException catch (e) {
    print('Error al subir: ${e.message}');
  }

  // ============================================
  // Ejemplo 14: API con múltiples niveles de anidación
  // ============================================

  try {
    // API retorna: { "response": { "body": { "data": {...} } } }
    final data = await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/complex/endpoint',
      converter: (response) {
        final level1 = response.data as Map<String, dynamic>;
        final level2 = level1['response'] as Map<String, dynamic>;
        final level3 = level2['body'] as Map<String, dynamic>;
        final actualData = level3['data'] as Map<String, dynamic>;

        return actualData;
      },
      requiresAuthToken: false,
    );

    print('Data extraída: $data');
  } on CustomException catch (e) {
    print('Error: ${e.message}');
  }

  // ============================================
  // Ejemplo 15: Uso con autenticación dinámica
  // ============================================

  try {
    // Obtener datos protegidos
    final protectedData = await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/protected/resource',
      converter: (response) => response.data as Map<String, dynamic>,
      requiresAuthToken: true, // El interceptor agregará el token
    );

    print('Data protegida: $protectedData');
  } on CustomException catch (e) {
    if (e.statusCode == 401) {
      print('Token expirado o inválido');
      // Aquí podrías renovar el token
    } else {
      print('Error: ${e.message}');
    }
  }
}

// ============================================
// Modelo de ejemplo
// ============================================

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(dynamic json) {
    final data = json as Map<String, dynamic>;
    return User(
      id: data['id'] as int,
      name: data['name'] as String,
      email: data['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
