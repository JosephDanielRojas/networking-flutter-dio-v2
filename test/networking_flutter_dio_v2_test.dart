import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:networking_flutter_dio_v2/networking_flutter_dio_v2.dart';

void main() {
  // Flag para controlar logs en tests
  // Cambia a false para desactivar logs
  const bool enableTestLogs = true;

  group('ApiClient Tests - Direct Dio Response', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late ApiClient apiClient;

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
      apiClient = ApiClient.fromDio(dio);
    });

    group('GET Method', () {
      test('should return Response<dynamic> on successful GET request', () async {
        // Arrange
        const endpoint = '/users';
        final mockData = {'id': 1, 'name': 'John Doe'};

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(200, mockData),
        );

        // Act
        final response = await apiClient.get(endpoint: endpoint);

        // Assert - Acceso directo a Response de Dio
        expect(response.statusCode, 200);
        expect(response.data, mockData);
        expect(response.data['name'], 'John Doe');
      });

      test('should throw CustomException on failed GET request', () async {
        // Arrange
        const endpoint = '/users';

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(404, {'message': 'Not found'}),
        );

        // Act & Assert
        expect(
          () async => await apiClient.get(endpoint: endpoint),
          throwsA(isA<CustomException>()),
        );
      });

      test('should handle query parameters in GET request', () async {
        // Arrange
        const endpoint = '/users';
        final queryParams = {'page': '1', 'limit': '10'};
        final mockData = [
          {'id': 1, 'name': 'User 1'},
          {'id': 2, 'name': 'User 2'}
        ];

        dioAdapter.onGet(
          endpoint,
          (server) => server.reply(200, mockData),
          queryParameters: queryParams,
        );

        // Act
        final response = await apiClient.get(
          endpoint: endpoint,
          queryParameters: queryParams,
        );

        // Assert
        expect(response.statusCode, 200);
        expect(response.data, isA<List>());
        expect((response.data as List).length, 2);
      });
    });

    group('POST Method', () {
      test('should return Response<dynamic> on successful POST request', () async {
        // Arrange
        const endpoint = '/users';
        final requestData = {'name': 'Jane Doe', 'email': 'jane@example.com'};
        final mockResponse = {'id': 2, 'name': 'Jane Doe', 'email': 'jane@example.com'};

        dioAdapter.onPost(
          endpoint,
          (server) => server.reply(201, mockResponse),
          data: requestData,
        );

        // Act
        final response = await apiClient.post(
          endpoint: endpoint,
          data: requestData,
        );

        // Assert
        expect(response.statusCode, 201);
        expect(response.data, mockResponse);
      });

      test('should throw CustomException on failed POST request', () async {
        // Arrange
        const endpoint = '/users';
        final requestData = {'name': '', 'email': 'invalid'};

        dioAdapter.onPost(
          endpoint,
          (server) => server.reply(400, {'message': 'Invalid data'}),
          data: requestData,
        );

        // Act & Assert
        expect(
          () async => await apiClient.post(endpoint: endpoint, data: requestData),
          throwsA(isA<CustomException>()),
        );
      });
    });

    group('PUT Method', () {
      test('should return Response<dynamic> on successful PUT request', () async {
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
        final response = await apiClient.put(
          endpoint: endpoint,
          data: requestData,
        );

        // Assert
        expect(response.statusCode, 200);
        expect(response.data, mockResponse);
      });

      test('should throw CustomException on failed PUT request', () async {
        // Arrange
        const endpoint = '/users/999';
        final requestData = {'name': 'Updated Name'};

        dioAdapter.onPut(
          endpoint,
          (server) => server.reply(404, {'message': 'User not found'}),
          data: requestData,
        );

        // Act & Assert
        expect(
          () async => await apiClient.put(endpoint: endpoint, data: requestData),
          throwsA(isA<CustomException>()),
        );
      });
    });

    group('PATCH Method', () {
      test('should return Response<dynamic> on successful PATCH request', () async {
        // Arrange
        const endpoint = '/users/1';
        final requestData = {'email': 'newemail@example.com'};
        final mockResponse = {'id': 1, 'name': 'John Doe', 'email': 'newemail@example.com'};

        dioAdapter.onPatch(
          endpoint,
          (server) => server.reply(200, mockResponse),
          data: requestData,
        );

        // Act
        final response = await apiClient.patch(
          endpoint: endpoint,
          data: requestData,
        );

        // Assert
        expect(response.statusCode, 200);
        expect(response.data, mockResponse);
      });

      test('should throw CustomException on failed PATCH request', () async {
        // Arrange
        const endpoint = '/users/1';
        final requestData = {'email': 'invalid-email'};

        dioAdapter.onPatch(
          endpoint,
          (server) => server.reply(400, {'message': 'Invalid email'}),
          data: requestData,
        );

        // Act & Assert
        expect(
          () async => await apiClient.patch(endpoint: endpoint, data: requestData),
          throwsA(isA<CustomException>()),
        );
      });
    });

    group('DELETE Method', () {
      test('should return Response<dynamic> on successful DELETE request', () async {
        // Arrange
        const endpoint = '/users/1';
        final mockResponse = {'message': 'User deleted successfully'};

        dioAdapter.onDelete(
          endpoint,
          (server) => server.reply(200, mockResponse),
        );

        // Act
        final response = await apiClient.delete(endpoint: endpoint);

        // Assert
        expect(response.statusCode, 200);
        expect(response.data, mockResponse);
      });

      test('should throw CustomException on failed DELETE request', () async {
        // Arrange
        const endpoint = '/users/999';

        dioAdapter.onDelete(
          endpoint,
          (server) => server.reply(404, {'message': 'User not found'}),
        );

        // Act & Assert
        expect(
          () async => await apiClient.delete(endpoint: endpoint),
          throwsA(isA<CustomException>()),
        );
      });
    });

    group('Interceptors', () {
      test('AuthInterceptor should update token', () {
        final authInterceptor = AuthInterceptor(token: 'initial_token', logAuthHeaders: false);

        expect(authInterceptor.token, 'initial_token');

        authInterceptor.updateToken('new_token');

        expect(authInterceptor.token, 'new_token');
      });

      test('LoggingInterceptor should be configurable', () {
        final loggingInterceptor = LoggingInterceptor(
          logRequest: false,
          logResponse: true,
          logError: true,
        );

        expect(loggingInterceptor.logRequest, false);
        expect(loggingInterceptor.logResponse, true);
        expect(loggingInterceptor.logError, true);
      });
    });
  });
}
