import 'package:dio/dio.dart';
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

/// Ejemplo simple de uso de la librería
/// Sin estructuras predefinidas - Responses directos de Dio
void main() async {
  // ============================================
  // OPCIÓN 1: Uso con ApiClient (Simple)
  // ============================================

  print('=== Ejemplo con ApiClient ===\n');

  final dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
  dio.interceptors.add(LoggingInterceptor());

  final apiClient = ApiClient(DioService(dioClient: dio));

  try {
    // GET - Retorna tipo T directamente
    final user = await apiClient.get<Map<String, dynamic>>(endpoint: '/users/1');

    // Acceso directo a los datos
    print('Usuario: ${user['name']}');
    print('Email: ${user['email']}\n');
  } on CustomException catch (e) {
    print('Error: ${e.message}\n');
  }

  try {
    // POST - Retorna tipo T directamente
    final newPost = await apiClient.post<Map<String, dynamic>>(
      endpoint: '/posts',
      data: {
        'title': 'Mi nuevo post',
        'body': 'Contenido del post',
        'userId': 1,
      },
    );

    print('Post creado - ID: ${newPost['id']}\n');
  } on CustomException catch (e) {
    print('Error: ${e.message}\n');
  }

  // ============================================
  // OPCIÓN 2: Uso con ApiService (Con Converters)
  // ============================================

  print('=== Ejemplo con ApiService ===\n');

  final dioForService = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  dioForService.interceptors.add(LoggingInterceptor());

  final dioService = DioService(dioClient: dioForService);
  final apiService = ApiService(dioService);

  try {
    // GET - Con converter personalizado
    final user = await apiService.getDocumentData<User>(
      endpoint: '/users/1',
      converter: (response) {
        // Acceso completo al Response de Dio
        print('Status Code: ${response.statusCode}');

        // Parsear a modelo personalizado
        return User.fromJson(response.data);
      },
      requiresAuthToken: false,
    );

    print('Usuario (modelo): ${user.name}');
    print('Email: ${user.email}\n');
  } on CustomException catch (e) {
    print('Error: ${e.message}\n');
  }

  try {
    // GET Collection - Lista de usuarios
    final users = await apiService.getCollectionData<User>(
      endpoint: '/users',
      converter: (response) {
        final list = response.data as List;
        return list.map((json) => User.fromJson(json)).toList();
      },
      queryParams: {'_limit': 3},
      requiresAuthToken: false,
    );

    print('Primeros 3 usuarios:');
    for (var user in users) {
      print('- ${user.name}');
    }
  } on CustomException catch (e) {
    print('Error: ${e.message}');
  }

  // ============================================
  // Ejemplo de manejo de diferentes formatos de API
  // ============================================

  print('\n=== Flexibilidad con diferentes APIs ===\n');

  try {
    // API que retorna: { "success": true, "data": {...}, "message": "OK" }
    final data = await apiService.getDocumentData<Map<String, dynamic>>(
      endpoint: '/users/1',
      converter: (response) {
        // Simular respuesta anidada
        // En una API real, podrías tener:
        // final wrapper = response.data as Map<String, dynamic>;
        // if (wrapper['success'] != true) throw Exception(wrapper['message']);
        // return wrapper['data'] as Map<String, dynamic>;

        // Para este ejemplo, retornamos directo
        return response.data as Map<String, dynamic>;
      },
      requiresAuthToken: false,
    );

    print('Data flexible: ${data['name']}\n');
  } on CustomException catch (e) {
    print('Error: ${e.message}\n');
  }

  // ============================================
  // Ejemplo con Headers personalizados
  // ============================================

  try {
    final post = await apiClient.get<Map<String, dynamic>>(
      endpoint: '/posts/1',
      queryParameters: {'_embed': 'comments'},
    );

    print('Post: ${post['title']}');
  } on CustomException catch (e) {
    print('Error: ${e.message}');
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
