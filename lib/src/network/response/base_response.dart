import 'package:equatable/equatable.dart';

abstract class BaseResponse<T> extends Equatable {
  T fromJson(Map<String, dynamic> json);
}
