import 'package:dio/dio.dart';

import 'request_model.dart';

var _header = <String, String>{};
var _token = <String, String>{};
var _baseUrl = '';
var _refreshToken = '';
var _acceptedLanguage = <String, String>{};

class BaseRequestDefaults {
  BaseRequestDefaults._();

  static final _instance = BaseRequestDefaults._();

  static BaseRequestDefaults get instance => _instance;

  void setHeader(Map<String, String> header) => _header = header;

  void setToken(String ntoken, {String? refreshToken}) {
    _token = {'Authorization': 'Bearer $ntoken'};
    if (refreshToken != null) {
      _refreshToken = refreshToken;
    }
  }

  String getToken() {
    return _token['Authorization'] ?? "";
  }

  void setAcceptedLanguage(String languageCode) {
    _acceptedLanguage = {'Accept-Language': languageCode == 'en' ? 'en-US' : "ar-EG"};
  }

  void removeToken() => _token = {};

  void setBaseUrl(String baseUrl) => _baseUrl = baseUrl;
}

abstract class BaseRequest {
  BaseRequest(this.path, this.method, this.queryParameters, this.requestModel, this.data);

  final RequestModel requestModel;
  final String path;
  final String method;
  final Future<dynamic> queryParameters;
  final Future<dynamic> data;
}

mixin Request implements BaseRequest {
  String get baseUrl => _baseUrl;

  String get refreshToken => _refreshToken;

  Map<String, String> get token => _token;

  String get url => baseUrl + path;

  CancelToken get cancelToken => requestModel.cancelToken;

  bool get includeAuthorization => true;

  bool get includeLocalization => true;

  bool get multiPart => false;

  bool get isEncoded => false;

  int? get sendTimeout => null;

  int? get receiveTimeout => null;

  Map<String, String>? get headers {
    final headers = <String, String>{};
    headers.addAll(_header);
    if (token.isNotEmpty && includeAuthorization) headers.addAll(token);
    if (isEncoded) {
      headers["content-Type"] = 'application/x-www-form-urlencoded';
    }
    if (_acceptedLanguage.isNotEmpty && includeLocalization) headers.addAll(_acceptedLanguage);
    return headers;
  }
}

mixin GetRequest on Request {
  @override
  RequestModel get requestModel => EmptyRequestModel();

  @override
  Future<dynamic> get queryParameters async {
    final map = await requestModel.toJson();
    if (map is Map<String, dynamic>) {
      return map.isEmpty ? null : map;
    }
  }

  @override
  Future<dynamic> get data async => null;

  @override
  String get method => 'GET';
}

mixin PostRequest on Request {
  @override
  Future<Map<String, dynamic>?> get queryParameters async => null;

  @override
  Future<dynamic> get data async {
    final map = await requestModel.toJson();
    if (map is Map<String, dynamic>) {
      if (map.isEmpty) return null;
      return multiPart ? FormData.fromMap(map) : map;
    } else {
      return map;
    }
  }

  @override
  String get method => 'POST';
}

mixin PutRequest on Request {
  @override
  Future<Map<String, dynamic>?> get queryParameters async => null;

  @override
  Future<dynamic> get data async {
    final map = await requestModel.toJson();
    if (map is Map<String, dynamic>) {
      if (map.isEmpty) return null;
      return multiPart ? FormData.fromMap(map) : map;
    } else {
      return map;
    }
  }

  @override
  String get method => 'PUT';
}

mixin DeleteRequest on Request {
  @override
  RequestModel get requestModel => EmptyRequestModel();

  @override
  Future<dynamic> get queryParameters async {
    final map = await requestModel.toJson();
    if (map is Map<String, dynamic>) {
      return map.isEmpty ? null : map;
    }
  }

  @override
  Future<dynamic> get data async => null;

  @override
  String get method => 'DELETE';
}
