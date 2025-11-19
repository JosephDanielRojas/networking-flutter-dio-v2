import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

void main() {
  // Flag para controlar logs en tests
  // Cambia a false para desactivar logs
  const bool enableTestLogs = true;

  group('ApiService Tests - Flexible Response', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late DioService dioService;
    late ApiService apiService;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

      // Agregar LoggingInterceptor para ver los logs en los tests
      if (enableTestLogs) {
        dio.interceptors.add(
          LoggingInterceptor(
            logRequest: true,
            logResponse: true,
            logError: true,
          ),
        );
      }

      dioAdapter = DioAdapter(dio: dio);
      dioService = DioService(dioClient: dio);
      apiService = ApiService(dioService);
    });

    group('getDocumentData', () {
      test('should return document with full Response access', () async {
        // Arrange
        const endpoint = '/user/1';
        final mockData = {'id': 1, 'name': 'John Doe'};

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(200, mockData),
        );

        // Act - Usuario tiene acceso completo al Response de Dio
        final result = await apiService.getDocumentData<Map<String, dynamic>>(
          endpoint: endpoint,
          converter: (response) {
            // El usuario puede acceder a todo:
            // response.data, response.statusCode, response.headers
            expect(response.statusCode, 200);
            expect(response.data, isA<Map>());
            return response.data as Map<String, dynamic>;
          },
          requiresAuthToken: false,
        );

        // Assert
        expect(result['id'], 1);
        expect(result['name'], 'John Doe');
      });

      test('should handle nested data structure', () async {
        // Arrange
        const endpoint = '/user/1';
        final mockData = {
          'success': true,
          'data': {'id': 1, 'name': 'John'},
          'message': 'Success'
        };

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(200, mockData),
        );

        // Act - Usuario extrae lo que necesita
        final result = await apiService.getDocumentData<Map<String, dynamic>>(
          endpoint: endpoint,
          converter: (response) {
            final data = response.data as Map<String, dynamic>;
            return data['data'] as Map<String, dynamic>;
          },
          requiresAuthToken: false,
        );

        // Assert
        expect(result['id'], 1);
        expect(result['name'], 'John');
      });
    });

    group('getCollectionData', () {
      test('should return list with flexible parsing', () async {
        // Arrange
        const endpoint = '/users';
        final mockData = [
          {'id': 1, 'name': 'User 1'},
          {'id': 2, 'name': 'User 2'}
        ];

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(200, mockData),
        );

        // Act
        final result = await apiService.getCollectionData<Map<String, dynamic>>(
          endpoint: endpoint,
          converter: (response) {
            final data = response.data as List;
            return data.map((item) => item as Map<String, dynamic>).toList();
          },
          requiresAuthToken: false,
        );

        // Assert
        expect(result.length, 2);
        expect(result[0]['name'], 'User 1');
      });

      test('should handle wrapped list response', () async {
        // Arrange
        const endpoint = '/users';
        final mockData = {
          'data': [
            {'id': 1, 'name': 'User 1'},
            {'id': 2, 'name': 'User 2'}
          ]
        };

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(200, mockData),
        );

        // Act - Usuario extrae la lista de donde esté
        final result = await apiService.getCollectionData<Map<String, dynamic>>(
          endpoint: endpoint,
          converter: (response) {
            final wrapper = response.data as Map<String, dynamic>;
            final list = wrapper['data'] as List;
            return list.map((item) => item as Map<String, dynamic>).toList();
          },
          requiresAuthToken: false,
        );

        // Assert
        expect(result.length, 2);
      });
    });

    group('postData', () {
      test('should send and parse POST request flexibly', () async {
        // Arrange
        const endpoint = '/users';
        final requestData = {'name': 'New User', 'email': 'new@example.com'};
        final mockResponse = {
          'id': 3,
          'name': 'New User',
          'email': 'new@example.com'
        };

        dioAdapter.onPost(
          endpoint,
          (server) => server.reply(201, mockResponse),
          data: requestData,
        );

        // Act
        final result = await apiService.postData<Map<String, dynamic>>(
          endpoint: endpoint,
          data: requestData,
          converter: (response) {
            expect(response.statusCode, 201);
            return response.data as Map<String, dynamic>;
          },
          requiresAuthToken: false,
        );

        // Assert
        expect(result['id'], 3);
        expect(result['name'], 'New User');
      });
    });

    group('putData', () {
      test('should send and parse PUT request flexibly', () async {
        // Arrange
        const endpoint = '/users/1';
        final requestData = {'name': 'Updated Name'};
        final mockResponse = {'id': 1, 'name': 'Updated Name'};

        dioAdapter.onPut(
          endpoint,
          (server) => server.reply(200, mockResponse),
          data: requestData,
        );

        // Act
        final result = await apiService.putData<Map<String, dynamic>>(
          endpoint: endpoint,
          data: requestData,
          converter: (response) => response.data as Map<String, dynamic>,
          requiresAuthToken: false,
        );

        // Assert
        expect(result['name'], 'Updated Name');
      });
    });

    group('patchData', () {
      test('should send and parse PATCH request flexibly', () async {
        // Arrange
        const endpoint = '/users/1';
        final requestData = {'email': 'updated@example.com'};
        final mockResponse = {'id': 1, 'email': 'updated@example.com'};

        dioAdapter.onPatch(
          endpoint,
          (server) => server.reply(200, mockResponse),
          data: requestData,
        );

        // Act
        final result = await apiService.patchData<Map<String, dynamic>>(
          endpoint: endpoint,
          data: requestData,
          converter: (response) => response.data as Map<String, dynamic>,
          requiresAuthToken: false,
        );

        // Assert
        expect(result['email'], 'updated@example.com');
      });
    });

    group('deleteData', () {
      test('should send and parse DELETE request flexibly', () async {
        // Arrange
        const endpoint = '/users/1';
        final mockResponse = {'message': 'User deleted successfully'};

        dioAdapter.onDelete(
          endpoint,
          (server) => server.reply(200, mockResponse),
        );

        // Act
        final result = await apiService.deleteData<Map<String, dynamic>>(
          endpoint: endpoint,
          converter: (response) => response.data as Map<String, dynamic>,
          requiresAuthToken: false,
        );

        // Assert
        expect(result['message'], 'User deleted successfully');
      });
    });

    group('Custom Models', () {
      test('should work with custom model classes', () async {
        // Arrange
        const endpoint = '/users/1';
        final mockData = {'id': 1, 'name': 'John', 'email': 'john@example.com'};

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(200, mockData),
        );

        // Act - Convertir directamente a modelo
        final result = await apiService.getDocumentData<User>(
          endpoint: endpoint,
          converter: (response) => User.fromJson(response.data),
          requiresAuthToken: false,
        );

        // Assert
        expect(result.name, 'John');
        expect(result.email, 'john@example.com');
      });
    });

    group('Headers and Query Params', () {
      test('should support custom headers', () async {
        // Arrange
        const endpoint = '/users';
        final customHeaders = {'X-Custom-Header': 'CustomValue'};

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(200, []),
          headers: customHeaders,
        );

        // Act
        await apiService.getCollectionData<Map<String, dynamic>>(
          endpoint: endpoint,
          converter: (response) => [],
          headers: customHeaders,
          requiresAuthToken: false,
        );

        // No exception means success
      });

      test('should support query parameters', () async {
        // Arrange
        const endpoint = '/users';
        final queryParams = {'page': 1, 'limit': 10};

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(200, []),
          queryParameters: queryParams,
        );

        // Act
        await apiService.getCollectionData<Map<String, dynamic>>(
          endpoint: endpoint,
          converter: (response) => [],
          queryParams: queryParams,
          requiresAuthToken: false,
        );

        // No exception means success
      });
    });
  });
}

// Modelo de ejemplo para tests
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
