import 'base_response.dart';

class EmptyResponseModel extends BaseResponse<EmptyResponseModel> {
  EmptyResponseModel();

  factory EmptyResponseModel.fromJson(Map<String, dynamic> json) => EmptyResponseModel();

  @override
  fromJson(Map<String, dynamic> json) => EmptyResponseModel.fromJson(json);

  @override
  List<Object?> get props => [];
}
