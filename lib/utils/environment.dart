import 'package:flutter/services.dart' show rootBundle;
import 'package:encrypt/encrypt.dart' as encrypt;

class Environment {
  static final Map<String, String> _envVariables = {};
  static const String aesKey = 'aqosTHW4iIlUdI2tE5KMZma7MN8OvvjZ';
  static const String ivKey = 'V5uuqCYpYwvfQEsQ';

  /// 환경변수 로드
  static Future<Map<String, String>> loadEncryptedEnv(String env) async {
    // AES 키와 IV 설정 (암호화에 사용된 것과 동일해야 함)
    final key = encrypt.Key.fromUtf8(aesKey);
    final iv = encrypt.IV.fromUtf8(ivKey);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // 암호화된 파일 읽기
    // final encryptedFile = File('assets/env/.env.$env'); // 암호화된 파일 경로
    final encryptedContent = await rootBundle
        .loadString('assets/env/.env.$env'); // encryptedFile.readAsString();

    // 복호화
    final decrypted = encrypter.decrypt64(encryptedContent, iv: iv);

    // 복호화된 내용을 파싱하여 환경변수로 저장
    return _parseEnv(decrypted);
  }

  /// 복호화된 문자열을 파싱하여 Map으로 변환
  static Map<String, String> _parseEnv(String content) {
    final lines = content.split('\n');
    for (var line in lines) {
      if (line.trim().isEmpty || line.startsWith('#')) continue;
      final parts = line.split('=');
      if (parts.length == 2) {
        _envVariables[parts[0].trim()] = parts[1].trim();
      }
    }

    return _envVariables;
  }

  /// 환경변수 값 가져오기
  static String get(String key) {
    return _envVariables[key] ?? '';
  }
}
