import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:product_manager/core/application_data.dart';
import 'package:product_manager/utils/environment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱 시작 전 초기화 절차를 수행하는 클래스
class AppLauncher {
  static final _path = 'assets/i18n';
  static final _supportLocales = [
    Locale('ko'),
    Locale('en'),
  ];

  /// 앱 실행 메서드
  static Future<void> run(Widget app) async {
    runApp(await init(app));
  }

  /// 초기화 메서드
  static Future<Widget> init(Widget app) async {
    await _ensureInitialized(); // 패키지 초기화
    await _environmentInitialize(); // 환경변수 초기화(로딩)
    
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Widget result = ProviderScope(child: app); // 상태관리 적용
    result = initializeLocalization(result); // 다국어 지원 적용

    return result;
  }

  /// 패키지 초기화 메서드
  static Future<void> _ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized(); // 다국어 지원을 위한 초기화
  }

  /// 환경변수 초기화 메서드
  static Future<void> _environmentInitialize() async {
    Map<String, String> env = await Environment.loadEncryptedEnv(const String.fromEnvironment('ENV')); // 암호화된 환경변수 로드
    ApplicationData.getInstance().setEnv(env); // 환경변수 저장
  }

  static Widget initializeLocalization(Widget app) {
    return EasyLocalization(
      supportedLocales: _supportLocales,
      fallbackLocale: const Locale('ko'),
      path: _path,
      child: app
    );
  }
}