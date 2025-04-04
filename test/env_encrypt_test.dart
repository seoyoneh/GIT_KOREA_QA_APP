// ignore_for_file: avoid_print
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() async {
  const String aesKey = 'aqosTHW4iIlUdI2tE5KMZma7MN8OvvjZ';
  const String ivKey = 'V5uuqCYpYwvfQEsQ';

  final key = encrypt.Key.fromUtf8(aesKey);
  final iv = encrypt.IV.fromUtf8(ivKey);

  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  // 파일 읽기
  final localFile = File('.env.local.decrypt');
  final devFile = File('.env.dev.decrypt');
  final prodFile = File('.env.prod.decrypt');

  final local = await localFile.readAsString();
  final dev = await devFile.readAsString();
  final prod = await prodFile.readAsString();

  final localEncrypted = encrypter.encrypt(local, iv: iv);
  final devEncrypted = encrypter.encrypt(dev, iv: iv);
  final prodEncrypted = encrypter.encrypt(prod, iv: iv);

  final localEncryptedFile = File('assets/env/.env.local');
  final devEncryptedFile = File('assets/env/.env.dev');
  final prodEncryptedFile = File('assets/env/.env.prod');

  await localEncryptedFile.writeAsString(localEncrypted.base64);
  print('파일이 성공적으로 암호화되었습니다: $localEncryptedFile');

  await devEncryptedFile.writeAsString(devEncrypted.base64);
  print('파일이 성공적으로 암호화되었습니다: $devEncryptedFile');

  await prodEncryptedFile.writeAsString(prodEncrypted.base64);
  print('파일이 성공적으로 암호화되었습니다: $prodEncryptedFile');
}
