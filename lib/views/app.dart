import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/core/provider/login_notifier.dart';
import 'package:product_manager/core/router/route_path.dart';
import 'package:product_manager/core/router/route_redirect.dart';

/// 앱 시작
class App extends ConsumerWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoApp.router(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      title: '서연이화 초중품관리앱',
      routerConfig: _getGoRouterConfig(ref), // GoRouter 설정
      theme: CupertinoThemeData(
        scaffoldBackgroundColor: QisColors.white.color
      ),
    );
  }

  // GoRouter Config
  GoRouter _getGoRouterConfig(WidgetRef ref) {
    final loginNotifier = ref.watch(loginProvider);

    return GoRouter(
      refreshListenable: loginNotifier, // 로그인 상태 변경 감지
      initialLocation: RoutePath.landing.path, // 초기 경로
      routes: RouteLocation.getRouteBases(), // 라우터 경로
      redirect: (BuildContext context, GoRouterState state) =>
          RouteRedirect.redirect(context, state, loginNotifier), // 리다이렉트(Guard)
    ); // GoRouter 초기화
  }
}