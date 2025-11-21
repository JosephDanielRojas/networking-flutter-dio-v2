# Networking Flutter Dio V2

Una librería Flutter para simplificar las peticiones HTTP usando Dio. Trabaja directamente con `Response<dynamic>` de Dio sin estructuras predefinidas, dándote control total sobre cómo parsear las respuestas de tu API.

## Características

- ✅ **5 Métodos HTTP**: GET, POST, PUT, PATCH, DELETE
- ✅ **Sin Estructuras Predefinidas**: Retorna `Response<dynamic>` directo de Dio
- ✅ **Flexibilidad Total**: Funciona con cualquier formato de API
- ✅ **Manejo de Errores**: CustomException con detalles completos
- ✅ **Interceptores**: Logging y autenticación incluidos
- ✅ **Pruebas Unitarias**: 24 tests pasando (100% cobertura)
- ✅ **Dos APIs**: ApiClient (simple) y ApiService (con converters)
- ✅ **Configuración Flexible**: Timeouts, headers y más

## Instalación

Agrega la dependencia en tu `pubspec.yaml`:

```yaml
dependencies:
  networking_flutter_dio_v2:
    git:"https://github.com/JosephDanielRojas/networking-flutter-dio-v2.git"
```

## Uso Básico

### Opción 1: ApiClient (Simple)

Usa `ApiClient` para peticiones directas que retornan `Response<dynamic>` de Dio:

```dart
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
);

// GET Request - Retorna Response<dynamic> de Dio
try {
  final response = await apiClient.get(
    endpoint: '/users',
    queryParameters: {'page': '1', 'limit': '10'},
  );

  // Acceso directo a los datos de Dio
  print('Status: ${response.statusCode}');
  print('Datos: ${response.data}');
  print('Headers: ${response.headers}');
} on CustomException catch (e) {
  print('Error: ${e.message} (${e.statusCode})');
}

// POST Request
try {
  final response = await apiClient.post(
    endpoint: '/users',
    data: {
      'name': 'Juan Pérez',
      'email': 'juan@example.com',
    },
  );

  print('Usuario creado: ${response.data}');
} on CustomException catch (e) {
  print('Error: ${e.message}');
}

// PUT Request
final response = await apiClient.put(
  endpoint: '/users/1',
  data: {'name': 'Juan Actualizado'},
);

// PATCH Request
final response = await apiClient.patch(
  endpoint: '/users/1',
  data: {'email': 'nuevo@example.com'},
);

// DELETE Request
final response = await apiClient.delete(endpoint: '/users/1');
```

### Opción 2: ApiService (Con Converters)

Usa `ApiService` para tener control total sobre el parsing de respuestas:

```dart
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
final dioService = DioService(dioClient: dio);
final apiService = ApiService(dioService);

// GET con converter personalizado
final user = await apiService.getDocumentData<User>(
  endpoint: '/users/1',
  converter: (response) {
    // Acceso completo al Response de Dio
    print('Status: ${response.statusCode}');
    print('Headers: ${response.headers}');

    // Retornar lo que necesites
    return User.fromJson(response.data);
  },
  requiresAuthToken: false,
);

// GET Collection
final users = await apiService.getCollectionData<User>(
  endpoint: '/users',
  converter: (response) {
    final list = response.data as List;
    return list.map((json) => User.fromJson(json)).toList();
  },
  queryParams: {'_limit': 5},
  requiresAuthToken: false,
);

// POST con parsing flexible
final newUser = await apiService.postData<User>(
  endpoint: '/users',
  data: {'name': 'Juan', 'email': 'juan@example.com'},
  converter: (response) {
    // Manejar diferentes formatos de API
    // Si tu API retorna: { "success": true, "data": {...} }
    // Puedes extraer solo la data:
    // final wrapper = response.data as Map<String, dynamic>;
    // return User.fromJson(wrapper['data']);

    // O retornar directo:
    return User.fromJson(response.data);
  },
  requiresAuthToken: false,
);
```

## Interceptores

### LoggingInterceptor

Interceptor para hacer logging de peticiones y respuestas:

```dart
final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  interceptors: [
    LoggingInterceptor(
      logRequest: true,
      logResponse: true,
      logError: true,
    ),
  ],
);
```

### AuthInterceptor

Interceptor para manejar autenticación con tokens:

```dart
final authInterceptor = AuthInterceptor(token: 'tu_token');

final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  interceptors: [authInterceptor],
);

// Actualizar el token dinámicamente
authInterceptor.updateToken('nuevo_token');
```

## Configuración Avanzada

### Timeouts y Headers Personalizados

```dart
final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Custom-Header': 'value',
  },
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
);
```

### Múltiples Interceptores

```dart
final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  interceptors: [
    LoggingInterceptor(),
    AuthInterceptor(token: 'token'),
    // Agrega tus propios interceptores aquí
  ],
);
```

## Manejo de Errores

La librería usa `CustomException` con información detallada de errores:

```dart
try {
  final response = await apiClient.get(endpoint: '/users/999');
  print('Usuario: ${response.data}');
} on CustomException catch (e) {
  print('Error: ${e.message}');
  print('Status Code: ${e.statusCode}');
  print('Tipo: ${e.exceptionType}');

  // Manejo específico por tipo
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
}
```

## Flexibilidad con Diferentes APIs

La librería funciona con **cualquier formato de API**:

```dart
// API que retorna datos directamente: { "id": 1, "name": "..." }
final user = await apiService.getDocumentData<Map<String, dynamic>>(
  endpoint: '/users/1',
  converter: (response) => response.data as Map<String, dynamic>,
  requiresAuthToken: false,
);

// API con wrapper: { "success": true, "data": {...}, "message": "OK" }
final user = await apiService.getDocumentData<Map<String, dynamic>>(
  endpoint: '/users/1',
  converter: (response) {
    final wrapper = response.data as Map<String, dynamic>;
    if (wrapper['success'] != true) {
      throw Exception(wrapper['message']);
    }
    return wrapper['data'] as Map<String, dynamic>;
  },
  requiresAuthToken: false,
);

// API con lista directa: [{"id": 1}, {"id": 2}]
final users = await apiService.getCollectionData<Map<String, dynamic>>(
  endpoint: '/users',
  converter: (response) {
    final list = response.data as List;
    return list.map((item) => item as Map<String, dynamic>).toList();
  },
  requiresAuthToken: false,
);

// API con lista anidada: { "data": [...], "total": 10 }
final users = await apiService.getCollectionData<Map<String, dynamic>>(
  endpoint: '/users',
  converter: (response) {
    final wrapper = response.data as Map<String, dynamic>;
    final list = wrapper['data'] as List;
    print('Total en API: ${wrapper['total']}');
    return list.map((item) => item as Map<String, dynamic>).toList();
  },
  requiresAuthToken: false,
);
```

## Pruebas Unitarias

La librería incluye **24 tests** usando `http_mock_adapter`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

void main() {
  test('should return Response<dynamic> on successful GET request', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    final dioAdapter = DioAdapter(dio: dio);
    final apiClient = ApiClient.fromDio(dio);

    dioAdapter.onGet('/users', (server) => server.reply(200, {'id': 1}));

    final response = await apiClient.get(endpoint: '/users');

    // Acceso directo al Response de Dio
    expect(response.statusCode, 200);
    expect(response.data['id'], 1);
  });
}
```

Para ejecutar las pruebas:

```bash
flutter test
# 24/24 tests pasando ✅
```

## Estructura del Proyecto

```
lib/
├── core/
│   ├── client/
│   │   └── api_client.dart             # Cliente simple
│   ├── networking/
│   │   ├── api_service.dart            # Servicio con converters
│   │   ├── api_interface.dart          # Interfaz
│   │   └── dio_service.dart            # Wrapper de Dio
│   ├── interceptors/
│   │   ├── logging_interceptor.dart    # Logging
│   │   ├── auth_interceptor.dart       # Autenticación
│   │   └── custom_exception.dart       # Manejo de errores
│   └── helper/
│       └── typedefs.dart               # Tipos reutilizables
└── networking_flutter_dio_v2.dart      # Archivo principal

example/
├── api_service_example.dart            # 15 ejemplos completos
└── simple_example.dart                 # Ejemplo básico
```

## Ejemplo Completo

```dart
import 'package:dio/dio.dart';
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

Future<void> main() async {
  // Opción 1: ApiClient (Simple)
  final apiClient = ApiClient(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    interceptors: [LoggingInterceptor()],
  );

  try {
    // GET - Retorna Response<dynamic> de Dio
    final response = await apiClient.get(endpoint: '/users/1');
    print('Usuario: ${response.data['name']}');
    print('Status: ${response.statusCode}');
  } on CustomException catch (e) {
    print('Error: ${e.message}');
  }

  // Opción 2: ApiService (Con Converters)
  final dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
  final apiService = ApiService(DioService(dioClient: dio));

  try {
    // GET con modelo personalizado
    final users = await apiService.getCollectionData<User>(
      endpoint: '/users',
      converter: (response) {
        final list = response.data as List;
        return list.map((json) => User.fromJson(json)).toList();
      },
      queryParams: {'_limit': 5},
      requiresAuthToken: false,
    );

    print('Primeros 5 usuarios:');
    for (var user in users) {
      print('- ${user.name} (${user.email})');
    }
  } on CustomException catch (e) {
    print('Error: ${e.message}');
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(dynamic json) {
    final data = json as Map<String, dynamic>;
    return User(
      id: data['id'] as int,
      name: data['name'] as String,
      email: data['email'] as String,
    );
  }
}
```

## Requisitos

- Flutter SDK: >=1.17.0
- Dart SDK: ^3.10.0
- Dio: ^5.9.0

## Licencia

Este proyecto está bajo la licencia MIT.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, crea un issue o pull request.

## Changelog

### 0.0.1
- Versión inicial
- Soporte para GET, POST, PUT, PATCH, DELETE
- Sin estructuras predefinidas - Retorna `Response<dynamic>` de Dio
- Dos APIs: ApiClient (simple) y ApiService (con converters)
- Flexibilidad total para cualquier formato de API
- Interceptores de logging y autenticación
- CustomException con 11 tipos de errores
- 24 pruebas unitarias (100% cobertura)
- 15 ejemplos de uso completos
