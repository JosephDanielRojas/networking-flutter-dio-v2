
import 'package:dio/dio.dart';
import '../helper/typedefs.dart';

abstract class ApiInterface {
  const ApiInterface();

  /// Elimina un recurso (DELETE)
  /// Retorna Response<dynamic> de Dio - El usuario tiene acceso completo a:
  Future<T> deleteData<T>({
    required String endpoint,
    required T Function(Response<dynamic> response) converter,
    Object? data,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
  });

  /// Obtiene una colección de datos (GET - Lista)
  ///
  /// Retorna Response<dynamic> de Dio para parsing flexible
  Future<List<T>> getCollectionData<T>({
    required String endpoint,
    required List<T> Function(Response<dynamic> response) converter,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
  });

  /// Obtiene un documento individual (GET - Objeto)
  ///
  /// Retorna Response<dynamic> de Dio para parsing flexible
  Future<T> getDocumentData<T>({
    required String endpoint,
    required T Function(Response<dynamic> response) converter,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
  });

  /// Crea un nuevo recurso (POST)
  ///
  /// Retorna Response<dynamic> de Dio para parsing flexible
  Future<T> postData<T>({
    required String endpoint,
    required T Function(Response<dynamic> response) converter,
    Object? data,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
    void Function(int count, int total)? onSendProgress,
  });

  /// Actualiza un recurso existente (PUT)
  ///
  /// Retorna Response<dynamic> de Dio para parsing flexible
  Future<T> putData<T>({
    required String endpoint,
    required T Function(Response<dynamic> response) converter,
    Object? data,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
  });

  /// Actualiza parcialmente un recurso (PATCH)
  ///
  /// Retorna Response<dynamic> de Dio para parsing flexible
  Future<T> patchData<T>({
    required String endpoint,
    required T Function(Response<dynamic> response) converter,
    Object? data,
    JSON? queryParams,
    JSON? headers,
    bool requiresAuthToken = true,
  });
}
