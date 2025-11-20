/// Tipos de excepciones personalizadas
enum ExceptionType {
  // Errores de autenticación/autorización
  tokenExpiredException,
  unauthorizedException,
  forbiddenException,

  // Errores de conexión/red
  connectionError,
  connectTimeoutException,
  sendTimeoutException,
  receiveTimeoutException,
  socketException,

  // Errores HTTP
  badResponse,
  notFoundException,
  validationException,
  tooManyRequestsException,
  serverException,
  badCertificateException,

  // Errores de datos
  formatException,
  serializationException,
  fetchDataException,

  // Otros errores
  cancelException,
  unrecognizedException,
  apiException,
}
