import 'dart:io';

import '../error/exceptions.dart';
import '../error/failure.dart';
import '../response/message_response.dart';

class FailureHandler {
  final Exception exception;

  FailureHandler(this.exception);

  //TODO add failure messages
  Failure getExceptionFailure() {
    try {
      switch (exception.runtimeType) {
        case SocketException:
          return NoConnectionFailure(message: "noConnection");

        case ServerException:
          var catchedException = exception as ServerException;
          return ServerFailure(message: MessageResponse.fromMap(catchedException.response?.data is Map ? catchedException.response?.data as Map<String, dynamic> : null).message);

        case CacheException:
          return ServerFailure();
        case ParsingException:
          return ParsingFailure();

        case BadRequestException:
          return ServerFailure();

        case InternalServerException:
          return ServerFailure();

        case AuthException:
          return AuthFailure();

        case UnExpectedException:
          return ServerFailure(message: "someThingWentWrong");
        case FormatException:
          return ParsingFailure();
        case ErrorException:
          var catchedException = exception as ErrorException;
          var errorMessage = catchedException.errorResponse as MessageResponse;
          return ServerFailure(message: errorMessage.message);
        case ConnectionException:
          return NoConnectionFailure(message: "noConnection");
        default:
          return ServerFailure();
      }
    } catch (e) {
      return UnhandledFailure(message: "somethingWentWrong");
    }
  }
}
