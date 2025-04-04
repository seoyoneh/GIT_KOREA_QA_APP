import 'package:product_manager/utils/environment.dart';

/// 요청 URL 목록 관리
class RequestUrl {
  static final RequestUrlType LOGIN = RequestUrlType(
    Environment.get("API_HOST"),
    '/api/auth/login',
    RequestMethod.POST); // 로그인
}

/// 요청 메서드
enum RequestMethod {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE;

  String get value {
    switch (this) {
      case RequestMethod.GET:
        return 'GET';
      case RequestMethod.POST:
        return 'POST';
      case RequestMethod.PUT:
        return 'PUT';
      case RequestMethod.PATCH:
        return 'PATCH';
      case RequestMethod.DELETE:
        return 'DELETE';
      }
  }
}

/// 요청 URL 타입
class RequestUrlType {
  const RequestUrlType(this.host, this.url, this.method);

  final String host;

  /// URL
  final String url;

  /// Method
  final RequestMethod method;
}