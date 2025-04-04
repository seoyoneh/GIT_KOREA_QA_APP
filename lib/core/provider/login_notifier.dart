// ChangeNotifier를 사용하는 로그인 상태 관리
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_manager/core/application_data.dart';

// 로그인 상태를 관리하는 ChangeNotifier 클래스
class LoginNotifier extends ChangeNotifier {
  bool _isLogIn = false;

  bool get isLogIn => _isLogIn;

  void login() {
    _isLogIn = true;
    notifyListeners();
  }

  void logout() async {
    ApplicationData.getInstance().clear();

    _isLogIn = false;
    notifyListeners();
  }
}

final loginProvider = ChangeNotifierProvider((ref) => LoginNotifier());
