import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 트랜지션 Factory
class TransionFactory {
  /// 슬라이드(Rright To Left) 트랜지션 페이지 반환
  static CustomTransitionPage getSlideTransitionPage(
      {required BuildContext context,
      required GoRouterState state,
      required Widget child}) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child),
    );
  }

  /// 슬라이드(Bottom to Left) 트랜지션 페이지 반환
  static CustomTransitionPage getPopupTransitionPage(
      {required BuildContext context,
      required GoRouterState state,
      required Widget child}) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child),
    );
  }

  /// 페이드 트랜지션 페이지 반환
  static CustomTransitionPage getFadeTransitionPage(
      {required BuildContext context,
      required GoRouterState state,
      required Widget child}) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 100),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: animation.drive(
          Tween<double>(
            begin: 0,
            end: 1,
          ).chain(CurveTween(curve: Curves.easeIn)),
        ),
        child: child,
      ),
    );
  }

  /// 스케일 트랜지션 페이지 반환
  static CustomTransitionPage getScaleTransitionPage(
      {required BuildContext context,
      required GoRouterState state,
      required Widget child}) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 100),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          ScaleTransition(
              scale: animation.drive(
                Tween<double>(
                  begin: 0.95,
                  end: 1,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: child,
              )),
    );
  }

  /// 트랜지션 없는 페이지 반환
  static Page<dynamic> Function(BuildContext context, GoRouterState state)
      noTransitionPageBuilder({required Widget child}) {
    return (context, state) => NoTransitionPage(child: child);
  }

  /// 슬라이드 트랜지션
  static Page<dynamic> Function(BuildContext context, GoRouterState state)
      getSlidePageBuilder({required Widget child}) {
    return (context, state) => TransionFactory.getSlideTransitionPage(
          context: context,
          state: state,
          child: child,
        );
  }

  /// 슬라이드 트랜지션
  static Page<dynamic> Function(BuildContext context, GoRouterState state)
      getPopupPageBuilder({required Widget child}) {
    return (context, state) => TransionFactory.getPopupTransitionPage(
          context: context,
          state: state,
          child: child,
        );
  }

  /// 페이드 트랜지션
  static Page<dynamic> Function(BuildContext context, GoRouterState state)
      getFadePageBuilder({required Widget child, GoRouterState? state}) {
    return (context, state) => TransionFactory.getFadeTransitionPage(
          context: context,
          state: state,
          child: child,
        );
  }

  /// 스케일 트랜지션
  static Page<dynamic> Function(BuildContext context, GoRouterState state)
      getScalePageBuilder({required Widget child}) {
    return (context, state) => TransionFactory.getScaleTransitionPage(
          context: context,
          state: state,
          child: child,
        );
  }
}
