import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:product_manager/constants/user_type.dart';
import 'package:product_manager/core/application_data.dart';
import 'package:product_manager/core/provider/login_notifier.dart';
import 'package:product_manager/core/router/route_path.dart';

class RouteRedirect {
  static FutureOr<String?> redirect(
    BuildContext context,
    GoRouterState state,
    LoginNotifier loginNotifier
  ) {
    String location = state.matchedLocation;

    List<String> excludePath = [
      RoutePath.landing.path,
      RoutePath.QIS002.path,
      RoutePath.QIS003.path,
      RoutePath.QIS004.path,
      RoutePath.QIS005.path,
    ];

    if(null == ApplicationData.getInstance().userToken && !excludePath.contains(state.matchedLocation)) {
      return RoutePath.QIS003.path; // 사용자 선택화면으로 이동
    }

    if((null != ApplicationData.getInstance().userToken
       && loginNotifier.isLogIn == true)
       && (location == RoutePath.QIS003.path
       || location == RoutePath.QIS004.path)
    ) {
      switch(ApplicationData.getInstance().userType) {
        case UserType.HQ:
          return RoutePath.QIS006.path;
        case UserType.PARTNER:
          return RoutePath.QIS007.path;
        default:
          //
          break;
      }
    }
    
    return null; // 로그인 화면으로 이동(혹은 로그인 베이스 화면)
  }
}