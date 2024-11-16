import 'dart:async';
import 'package:an_core/an_core.dart';
import 'package:dio/dio.dart' hide ResponseType;
import 'package:injectable/injectable.dart';

import 'index.dart';

abstract class Network {
  Future<AppResponse<T>> send<T extends BaseResponse<T>>({
    required Request request,
    T? responseObject,
    required ResponseType responseType,
  });
}

@LazySingleton(as: Network)
class NetworkImpl implements Network {
  NetworkImpl(this.appLogger, {this.interceptors}) {
    _dio.interceptors.addAll([appLogger, if (interceptors != null) ...interceptors!]);
  }

  final AppLogger appLogger;
  final List<Interceptor>? interceptors;
  final int timeOutInMilliseconds = 40000;
  final StatusChecker _statusChecker = StatusChecker();
  final Dio _dio = Dio();

  @override
  Future<AppResponse<T>> send<T extends BaseResponse<T>>({
    required Request request,
    T? responseObject,
    ResponseType responseType = ResponseType.single,
  }) async {
    try {
      if (responseObject == null && responseType != ResponseType.singleWithoutData) {
        throw const ParsingException();
      }

      final response = await _requestPayload(request);
      if (response.data is Map<String, dynamic> && (response.data?.containsKey("errorCode"))) {
        throw Exceptions.serverException(response);
      }
      try {
        return _retrieveResponse<T>(response.data, responseObject, responseType);
      } catch (e) {
        throw const ParsingException();
      }
    } on DioException catch (error) {
      if (error.type == DioExceptionType.badResponse) {
        final HTTPCodes statusCode = _statusChecker(error.response!.statusCode);
        if (error.response?.statusCode != null && (statusCode == HTTPCodes.error || statusCode == HTTPCodes.serviceNotAvailable)) {
          // debugPrint((error.response?.statusCode != null && _statusChecker(error.response!.statusCode) == HTTPCodes.error).toString());
          try {
            if (error.response!.statusCode == 401) {
              throw const Exceptions.authException();
            }
            final serverMessage = MessageResponse.fromMap(error.response?.data is Map<String, dynamic> ? error.response?.data as Map<String, dynamic> : null);
            throw Exceptions.errorException(
              error.response!.statusCode!,
              serverMessage,
              // errorResponseFromMap != null
              // /    ? errorResponseFromMap(error.response!.data as Map<String, dynamic>)
              //     : MessageResponse.fromMap(error.response?.data is Map<String, dynamic> ? error.response?.data as Map<String, dynamic> : null),
            );
          } catch (exception) {
            rethrow;
          }
        } else {
          throw Exceptions.serverException(error.response!);
        }
      }

      throw throwExceptionType(error);
    } catch (exception) {
      if (exception is ParsingException) {
        rethrow;
      } else {
        throw UnimplementedError();
      }
    }
  }

  Future<Response> _requestPayload(Request request) async {
    try {
      final data = await request.data;
      final requestPayload = _dio.request(
        request.url,
        data: data,
        queryParameters: await request.queryParameters,
        cancelToken: request.cancelToken,
        onSendProgress: request.requestModel.progressListener?.onSendProgress,
        onReceiveProgress: request.requestModel.progressListener?.onReceiveProgress,
        options: Options(
          headers: request.headers,
          method: request.method,
          sendTimeout: Duration(milliseconds: request.sendTimeout ?? timeOutInMilliseconds),
          receiveTimeout: Duration(milliseconds: request.receiveTimeout ?? timeOutInMilliseconds),
        ),
      );
      return requestPayload;
    } catch (error) {
      throw const Exceptions.parsingException();
    }
  }

  Exceptions throwExceptionType(DioException error) => switch (error.type) {
        DioExceptionType.connectionTimeout => throw const ConnectionException(),
        DioExceptionType.sendTimeout => throw const ConnectionException(),
        DioExceptionType.receiveTimeout => throw const ConnectionException(),
        DioExceptionType.cancel => throw const RequestCanceledException(),
        DioExceptionType.badResponse => throw const UnExpectedException(),
        DioExceptionType.unknown => error.message?.contains('SocketException') ?? false ? throw const ConnectionException() : throw const UnExpectedException(),
        DioExceptionType.badCertificate => throw const UnExpectedException(),
        DioExceptionType.connectionError => throw const ConnectionException(),
      };

  AppResponse<T> _retrieveResponse<T extends BaseResponse<T>>(dynamic json, T? object, ResponseType responseType) {
    return switch (responseType) {
      ResponseType.single => AppResponseSingleResult<T>.fromJson(json, object!),
      ResponseType.singleWithoutData => AppResponseSingleResult<T>.fromJsonWithoutData(json),
      ResponseType.list => AppResponseListResult<T>.fromJson(json, object!),
    };
  }
}
