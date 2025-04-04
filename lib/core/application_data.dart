import 'package:product_manager/constants/user_type.dart';
import 'package:product_manager/models/inspection/inspection_type.dart';
import 'package:product_manager/models/login/token_type.dart';

class ApplicationData {
  static ApplicationData? _instance;

  // private 생성자
  ApplicationData._internal();

  // 싱글톤 인스턴스를 지연 초기화하는 방법
  static ApplicationData getInstance() {
    // null-aware 연산자로 null일 때만 초기화
    _instance ??= ApplicationData._internal();
    return _instance!;
  }

  void clear() {
    _userToken = null; // 로그인 토큰
    _userType = null; // 사용자 유형
    _inspectionCheckType = null; // 검사지시서 체크여부
  }
  //-----------------------------------------------
  // 환경변수
  //-----------------------------------------------
  Map<String, String>? _env; // 환경변수

  /// 환경변수 저장
  void setEnv(Map<String, String> env) {
    _env = env;
  }

  /// 저장되어있는 환경변수 조회
  Map<String, String> getEnv() {
    return _env ?? {};
  }

  /// 환경변수 값 조회
  String getEnvValue(String key) {
    return ApplicationData.getInstance().getEnv()[key] ?? '';
  }

  //-----------------------------------------------
  // 검사지시서
  //-----------------------------------------------
  /// 검사지시서 체크여부
  InspectionCheckType? _inspectionCheckType;
  InspectionCheckType? get inspectionCheckType => _inspectionCheckType;
  set inspectionCheckType(InspectionCheckType? value) {
    _inspectionCheckType = value;
  }

  //-----------------------------------------------
  // 로그인 토큰
  //-----------------------------------------------
  JWTTokenType? _userToken; // 로그인 토큰
  JWTTokenType? get userToken => _userToken;
  set userToken(JWTTokenType? value) {
    _userToken = value;
  }

  //-----------------------------------------------
  // 사용자 유형
  //-----------------------------------------------
  UserType? _userType; // 사용자 유형
  UserType? get userType => _userType;
  set userType(UserType? value) {
    _userType = value;
  }
}