import 'package:dio/dio.dart';

/// Extensions para facilitar la extracción de datos de Response
///
/// Proporciona métodos helper para manejar diferentes estructuras de respuesta
/// sin necesidad de código repetitivo en los converters
extension ResponseExtensions on Response {
  /// Extrae colecciones de varias estructuras de respuesta
  ///
  /// Maneja automáticamente:
  /// - Arrays directos: `[{...}, {...}]`
  /// - Arrays anidados: `{"data": [{...}], "meta": {...}}`
  /// - Múltiples claves posibles
  ///
  /// Ejemplo:
  /// ```dart
  /// converter: (response) {
  ///   return response.getCollection(possibleKeys: ['todos', 'data', 'items'])
  ///     .map((json) => TodoModel.fromJson(json))
  ///     .toList();
  /// }
  /// ```
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

  /// Extrae un documento de varias estructuras de respuesta
  ///
  /// Maneja automáticamente:
  /// - Objetos directos: `{"id": 1, "name": "..."}`
  /// - Objetos anidados: `{"data": {"id": 1}, "meta": {...}}`
  /// - Múltiples claves posibles
  ///
  /// Ejemplo:
  /// ```dart
  /// converter: (response) {
  ///   final doc = response.getDocument(possibleKeys: ['data', 'item']);
  ///   return doc != null ? UserModel.fromJson(doc) : null;
  /// }
  /// ```
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

      // Si no se encuentra en las claves, asumir que el Map completo es el documento
      // (esto maneja el caso donde la API retorna directamente el objeto sin envoltura)
      return data;
    }

    return null;
  }

  /// Extrae un valor específico de la respuesta
  ///
  /// Útil para extraer valores primitivos o metadata
  ///
  /// Ejemplo:
  /// ```dart
  /// final total = response.getValue<int>('total', defaultValue: 0);
  /// final message = response.getValue<String>('message');
  /// ```
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

  /// Verifica si la respuesta contiene una clave específica
  ///
  /// Ejemplo:
  /// ```dart
  /// if (response.hasKey('error')) {
  ///   // Manejar error
  /// }
  /// ```
  bool hasKey(String key) {
    if (data is Map<String, dynamic>) {
      return data.containsKey(key);
    }
    return false;
  }

  /// Extrae metadata de la respuesta
  ///
  /// Útil para obtener información adicional como paginación
  ///
  /// Ejemplo:
  /// ```dart
  /// final meta = response.getMetadata(keys: ['pagination', 'meta', 'info']);
  /// final totalPages = meta?['totalPages'];
  /// ```
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
