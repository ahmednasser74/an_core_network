import 'network_enum.dart';

class StatusChecker {
  final success = [200, 201, 202, 204];
  final validationError = [400, 409, 422];
  final redirectError = [301, 302, 303, 307, 308];
  final authorizationError = [401];
  final authenticationError = [403];
  final methodNotAllowedError = [405];
  final resourceNotFoundError = [410];
  final invalidToken = [406];
  final serviceNotAvailable = [404, ..._range(500, 599)];

  HTTPCodes call(int? statusCode) {
    final error = validationError + authorizationError + authenticationError + resourceNotFoundError + methodNotAllowedError;
    if (success.contains(statusCode)) return HTTPCodes.success;
    if (error.contains(statusCode)) return HTTPCodes.error;
    if (invalidToken.contains(statusCode)) return HTTPCodes.invalidToken;
    if (redirectError.contains(statusCode)) return HTTPCodes.redirect;
    if (serviceNotAvailable.contains(statusCode)) {
      return HTTPCodes.serviceNotAvailable;
    } else {
      return HTTPCodes.unknown;
    }
  }

  ErrorStatus getErrorState(int? statusCode) {
    if (validationError.contains(statusCode)) {
      return ErrorStatus.validationError;
    } else if (authorizationError.contains(statusCode)) {
      return ErrorStatus.authorizationError;
    } else if (authenticationError.contains(statusCode)) {
      return ErrorStatus.authenticationError;
    } else if (resourceNotFoundError.contains(statusCode)) {
      return ErrorStatus.resourceNotFoundError;
    } else if (redirectError.contains(statusCode)) {
      return ErrorStatus.redirectError;
    }
    return ErrorStatus.unknownError;
  }
}

Iterable<int> _range(int from, int to) => Iterable<int>.generate(to - from + 1, (i) => i + from);
