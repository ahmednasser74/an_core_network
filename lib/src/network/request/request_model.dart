import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class RequestModel extends Equatable {
  @JsonKey(includeFromJson: false, includeToJson: false)
  final RequestProgressListener? progressListener;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final CancelToken cancelToken = CancelToken();

  RequestModel(this.progressListener);

  void cancelRequest([dynamic reason]) => cancelToken.cancel(reason);

  Map<String, dynamic> toJson();

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => super.hashCode;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  bool? get stringify => super.stringify;
}

class RequestProgressListener {
  RequestProgressListener({this.onSendProgress, this.onReceiveProgress});

  final Function(int, int)? onSendProgress;
  final Function(int, int)? onReceiveProgress;
}

class EmptyRequestModel extends RequestModel {
  EmptyRequestModel({RequestProgressListener? progressListener}) : super(progressListener);

  @override
  List<Object?> get props => [];

  @override
  Map<String, dynamic> toJson() => {};
}
