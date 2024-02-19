import 'base_response.dart';

class MessageResponse extends BaseResponse<MessageResponse> {
  MessageResponse({required this.message});

  factory MessageResponse.fromMap(Map<String, dynamic>? map) => MessageResponse(
      message: map?['message'] as String? ??
          map?['msg'] as String? ??
          map?['OperationMessage'] as String? ??
          map?['operationMessage'] as String? ??
          map?['error_description'] as String? ??
          map?['errorCode'] ??
          map?['error'] ??
          "somethingWentWrong");

  final String message;

  @override
  List<Object?> get props => [message];

  Map<String, dynamic> toMap() {
    return {'message': message};
  }

  @override
  MessageResponse fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
