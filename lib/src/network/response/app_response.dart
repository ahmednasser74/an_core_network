import '../index.dart';

abstract class AppResponse<T extends BaseResponse<T>> {
  AppResponse(this.message, this.code);
  int code = 500;
  // bool httpCode;
  String? message;
  bool status = false;
  List<String>? errors;
  final StatusChecker _checker = StatusChecker();

  AppResponse.fromJson(Map<String, dynamic> json, T object) {
    message = (json['message'] as String?) ?? '';
    code = json['code'] as int;
    status = json['status'] as bool;
    errors = json['errors'] == null ? null : (json['errors'] as List<dynamic>).map((e) => e.toString()).toList();
    if (json['data'] != null) {
      serializeResult(json['data'], object);
    }
  }
  bool get isSuccess => _checker(code) == HTTPCodes.success;

  AppResponse.fromJsonWithoutData(Map<String, dynamic> json) {
    message = (json['message'] as String?) ?? '';
    code = json['code'] as int;
    errors = json['errors'] == null ? null : (json['errors'] as List<dynamic>).map((e) => e.toString()).toList();
  }

  void serializeResult(dynamic json, T object);
}

class AppResponseSingleResult<T extends BaseResponse<T>> extends AppResponse<T> {
  AppResponseSingleResult(String message, int status) : super(message, status);

  AppResponseSingleResult.fromJson(Map<String, dynamic> json, T object) : super.fromJson(json, object);

  AppResponseSingleResult.fromJsonWithoutData(Map<String, dynamic> json) : super.fromJsonWithoutData(json);

  T? result;

  @override
  void serializeResult(dynamic dataJson, T object) {
    result = dataJson == null ? null : object.fromJson(dataJson as Map<String, dynamic>);
  }
}

class AppResponseListResult<T extends BaseResponse<T>> extends AppResponse<T> {
  AppResponseListResult(String message, int status) : super(message, status);

  AppResponseListResult.fromJson(Map<String, dynamic> json, T object) : super.fromJson(json, object);
  List<T>? results;

  @override
  void serializeResult(dynamic dataJson, T object) {
    results = (dataJson as List<dynamic>).map((dynamic e) => object.fromJson(e as Map<String, dynamic>)).toList();
  }
}
