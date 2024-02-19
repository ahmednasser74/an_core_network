enum ErrorStatus {
  validationError,
  authorizationError,
  authenticationError,
  resourceNotFoundError,
  unknownError,
}

enum HTTPCodes {
  success,
  error,
  invalidToken,
  serviceNotAvailable,
  unknown,
}

enum ResponseType {
  single,
  singleWithoutData,
  list,
}
