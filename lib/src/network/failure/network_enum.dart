enum ErrorStatus {
  validationError,
  authorizationError,
  authenticationError,
  resourceNotFoundError,
  redirectError,
  unknownError,
}

enum HTTPCodes {
  success,
  error,
  invalidToken,
  serviceNotAvailable,
  unknown,
  redirect,
}

enum ResponseType {
  single,
  singleWithoutData,
  list,
}
