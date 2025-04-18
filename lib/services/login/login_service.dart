import 'package:flutter/cupertino.dart';
import 'package:product_manager/core/application_data.dart';
import 'package:product_manager/core/net/http_request.dart';
import 'package:product_manager/core/net/request_url.dart';
import 'package:product_manager/models/login/token_type.dart';

class LoginService {
  static LoginService? _instance;

  // private 생성자
  LoginService._internal();

  // 싱글톤 인스턴스를 지연 초기화하는 방법
  static LoginService getInstance() {
    // null-aware 연산자로 null일 때만 초기화
    _instance ??= LoginService._internal();
    return _instance!;
  }

  /// 로그인하기
  /// [username] : 사용자 이름
  /// [password] : 비밀번호
  Future<JWTTokenType?> login ({
    required BuildContext context,
    required String username,
    required String password,
    required String langSet
  }) async{
    Map<String, String> params = {
      'username': username,
      'password': password,
      'langSet': langSet
    };

    dynamic response = await HttpRequest.request(context, urlType: RequestUrl.LOGIN, params: params);
    dynamic data = response.data;
    
    if(data['error'] == null) {
      // 로그인 성공
      JWTTokenType token = JWTTokenType.fromJson(data);

      ApplicationData.getInstance().userToken = token;
      return token;
      // App.getInstance().userToken = token;
    } else {
      // 로그인 실패
    }

    return null;
  }
}