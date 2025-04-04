import 'dart:io';

/// 플랫폼 관련 유틸리티
class PlatformUtil {
  /// 언어 코드를 반환한다.
  static String getLanguageCode() {
    String code = Platform.localeName.split("_")[0].toLowerCase();
    return code;
  }

  /// 플랫폼을 반환한다.
  static String getPlatform() {
    if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS) {
      return "ios";
    } else if (Platform.isMacOS) {
      return "macos";
    } else if (Platform.isWindows) {
      return "windows";
    } else if (Platform.isLinux) {
      return "linux";
    } else {
      return "unknown";
    }
  }
}