import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../response/base_response.dart';

// import 'package:http/http.dart';

abstract class Exceptions extends Equatable implements Exception {
  const Exceptions._();

  const factory Exceptions.serverException(Response? response) = ServerException;
  const factory Exceptions.errorException(int statusCode, BaseResponse errorResponse) = ErrorException;
  const factory Exceptions.cacheException() = CacheException;
  const factory Exceptions.parsingException() = ParsingException;
  const factory Exceptions.badRequestException(Response? response) = BadRequestException;
  const factory Exceptions.internalServerException(Response? response) = InternalServerException;
  const factory Exceptions.authException() = AuthException;
  const factory Exceptions.unExpectedException() = UnExpectedException;
  const factory Exceptions.validationException(String value) = ValidationException;
}

class ErrorException extends Exceptions {
  const ErrorException(this.statusCode, this.errorResponse) : super._();

  final int statusCode;
  final BaseResponse errorResponse;

  @override
  List<Object?> get props => [statusCode, errorResponse];
}

class ServerException extends Exceptions {
  const ServerException(this.response) : super._();

  final Response? response;

  @override
  List<Object?> get props => [response];
}

class CacheException extends Exceptions {
  const CacheException() : super._();

  @override
  List<Object?> get props => [];
}

class ParsingException extends Exceptions {
  const ParsingException() : super._();

  @override
  List<Object?> get props => [];
}

class BadRequestException extends Exceptions {
  const BadRequestException(this.response) : super._();
  final Response? response;
  @override
  List<Object?> get props => [];
}

class InternalServerException extends Exceptions {
  const InternalServerException(this.response) : super._();
  final Response? response;
  @override
  List<Object?> get props => [response];
}

class AuthException extends Exceptions {
  const AuthException() : super._();
  @override
  List<Object?> get props => [];
}

class ValidationException extends Exceptions {
  const ValidationException(this.value) : super._();

  final String? value;

  @override
  List<Object?> get props => [value];
}

class UnExpectedException extends Exceptions {
  const UnExpectedException() : super._();

  @override
  List<Object?> get props => [];
}

class ConnectionException extends Exceptions {
  const ConnectionException() : super._();

  @override
  List<Object?> get props => [];
}

class RequestCanceledException extends Exceptions {
  const RequestCanceledException() : super._();

  @override
  List<Object?> get props => [];
}
