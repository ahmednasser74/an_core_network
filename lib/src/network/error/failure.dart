abstract class Failure {
  final String? message;
  final String? code;

  Failure({this.message = 'somethingWentWrong', this.code = "1"});
}

abstract class ConnectionFailure extends Failure {
  ConnectionFailure({
    String? message,
  }) : super(message: message);
}

//General Failures

class ServerFailure extends ConnectionFailure {
  ServerFailure({
    String? message,
  }) : super(message: message);
}

class AuthFailure extends ConnectionFailure {
  AuthFailure({
    String? message,
  }) : super(message: "unAuth");
}

class ParsingFailure extends Failure {
  ParsingFailure() : super(message: "Parsing failure");
}

class DocumentTypeNotRecognizedFailure extends Failure {
  DocumentTypeNotRecognizedFailure()
      : super(message: "DocumentTypeNotRecognized");
}

class CacheFailure extends Failure {
  CacheFailure() : super(message: "Caching failure");
}

class PaymentFailure extends Failure {
  PaymentFailure({
    String? message,
    String? code,
  }) : super(message: message, code: code);
}

class NoConnectionFailure extends ConnectionFailure {
  NoConnectionFailure({
    String? message,
  }) : super(message: message);
}

class ValidationFailure extends Failure {
  final String? additionalArg;
  ValidationFailure({
    String? message,
    this.additionalArg,
  }) : super(message: message);
}

class PermissionFailure extends Failure {
  PermissionFailure({
    String? message,
  }) : super(message: message);
}

class SessionEndedFailure extends ConnectionFailure {
  SessionEndedFailure({
    String? message,
  }) : super(message: message);
}

class INITFailure extends Failure {
  INITFailure({
    String? message,
  }) : super(message: message);
}

class UnhandledFailure extends Failure {
  UnhandledFailure({
    String? message,
  }) : super(message: message);
}

class DocumentSidesNotMatchFailure extends Failure {
  DocumentSidesNotMatchFailure() : super(message: 'expiredId');
}

class DocumentExpiredFailure extends Failure {
  DocumentExpiredFailure() : super(message: 'backSideNotTheSameAsTheFront');
}
