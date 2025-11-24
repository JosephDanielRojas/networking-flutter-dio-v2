import 'package:dio/dio.dart';

extension ResponseExtensions on Response {
  List<dynamic> getCollection({
    List<String> possibleKeys = const ['data', 'items', 'results', 'list'],
  }) {
    // Si response.data ya es una Lista, devolverla directamente
    if (data is List) {
      return data as List<dynamic>;
    }

    // Si es un Map, intentar encontrar el array en las claves proporcionadas
    if (data is Map<String, dynamic>) {
      for (final key in possibleKeys) {
        final value = data[key];
        if (value != null && value is List) {
          return value;
        }
      }
    }

    // Si no se encuentra nada, retornar lista vacía
    return [];
  }

  Map<String, dynamic>? getDocument({
    List<String> possibleKeys = const ['data', 'item', 'result', 'document'],
  }) {
    // Si response.data ya es un Map directo, intentar devolverlo
    if (data is Map<String, dynamic>) {
      // Primero intentar encontrar en las claves proporcionadas
      for (final key in possibleKeys) {
        final value = data[key];
        if (value != null && value is Map<String, dynamic>) {
          return value;
        }
      }
      return data;
    }

    return null;
  }
  T? getValue<T>(
    String key, {
    T? defaultValue,
    List<String> possibleKeys = const [],
  }) {
    if (data is Map<String, dynamic>) {
      // Intentar con la clave principal
      if (data.containsKey(key) && data[key] is T) {
        return data[key] as T;
      }

      // Intentar con claves alternativas
      for (final altKey in possibleKeys) {
        if (data.containsKey(altKey) && data[altKey] is T) {
          return data[altKey] as T;
        }
      }
    }

    return defaultValue;
  }
  bool hasKey(String key) {
    if (data is Map<String, dynamic>) {
      return data.containsKey(key);
    }
    return false;
  }
  Map<String, dynamic>? getMetadata({
    List<String> keys = const ['meta', 'metadata', 'pagination', 'info'],
  }) {
    if (data is Map<String, dynamic>) {
      for (final key in keys) {
        final value = data[key];
        if (value != null && value is Map<String, dynamic>) {
          return value;
        }
      }
    }
    return null;
  }
}
