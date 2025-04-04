import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:product_manager/core/router/transition_factory.dart';
import 'package:product_manager/views/QIS002.dart';
import 'package:product_manager/views/inspection/CameraView.dart';
import 'package:product_manager/views/inspection/QIS008.dart';
import 'package:product_manager/views/inspection/QIS009.dart';
import 'package:product_manager/views/inspection/QIS010.dart';
import 'package:product_manager/views/inspection/QIS011.dart';
import 'package:product_manager/views/inspection/QIS012.dart';
import 'package:product_manager/views/landing.dart';
import 'package:product_manager/views/signin/QIS003.dart';
import 'package:product_manager/views/signin/QIS004.dart';
import 'package:product_manager/views/signin/QIS005.dart';
import 'package:product_manager/views/work_info/QIS006.dart';
import 'package:product_manager/views/work_info/QIS007.dart';

enum RoutePath {
  landing(path: '/landing'), // 홈화면
  QIS002(path: '/QIS002'), // 앱접근권한 안내
  QIS003(path: '/signin/QIS003'), // 회원타입 선택화면
  QIS004(path: '/signin/QIS004'), // 서연이화 사용자 로그인 화면
  QIS005(path: '/signin/QIS005'), // 협력사 직원 로그인 화면
  QIS006(path: '/work_info/QIS006'), // 작업 정보 입력화면(서연이화)
  QIS007(path: '/work_info/QIS007'), // 작업정보 입력화면(협력사)
  QIS008(path: '/inspection/QIS008'), // 외관검사결과 목록화면(서연이화)
  QIS009(path: '/inspection/QIS009'), // 외관검사결과 목록화면(협력사)
  QIS010(path: '/inspection/QIS010'), // 외관검사결과 등록화면(서연이화)
  QIS011(path: '/inspection/QIS011'), // 외관검사결과 등록화면(협력사)
  QIS012(path: '/inspection/QIS012'), // 검사기준서화면
  CameraView(path: '/inspection/CameraView'), // 검사기준서화면
  ;

  final String path;
  const RoutePath({required this.path});
}

/// GoRoute의 Route 경로를 관리하는 클래스
class RouteLocation {
  
  /// 정의된 라우터 경로목록을 반환하는 메서드
  static List<RouteBase> getRouteBases() {
    return [
      GoRoute(
        path: RoutePath.landing.path,
        pageBuilder: TransionFactory.getFadePageBuilder(
          child: const LandingPage(key: Key('QIS_LANDING_PAGE')))), // 랜딩페이지
      GoRoute(
        path: RoutePath.QIS002.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const QIS002(key: Key('QIS002')))), // 앱접근권한 안내
      GoRoute(
        path: RoutePath.QIS003.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const QIS003(key: Key('QIS003')))), // 회원타입 선택화면
      GoRoute(
        path: RoutePath.QIS004.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const QIS004(key: Key('QIS004')))), // 서연이화 사용자 로그인 화면
      GoRoute(
        path: RoutePath.QIS005.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const QIS005(key: Key('QIS005')))), // 협력사 직원 로그인 화면
      GoRoute(
        path: RoutePath.QIS006.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const QIS006(key: Key('QIS006')))), // 작업 정보 입력화면(서연이화)
      GoRoute(
        path: RoutePath.QIS007.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const QIS007(key: Key('QIS007')))), // 작업정보 입력화면(협력사)
      GoRoute(
        path: RoutePath.QIS008.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const QIS008(key: Key('QIS008')))), // 외관검사결과 목록화면(서연이화)
      GoRoute(
        path: RoutePath.QIS009.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const QIS009(key: Key('QIS009')))), // 외관검사결과 목록화면(협력사)
      GoRoute(
        path: RoutePath.QIS010.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const QIS010(key: Key('QIS010')))), // 외관검사결과 등록화면(서연이화)
      GoRoute(
        path: RoutePath.QIS011.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const QIS011(key: Key('QIS011')))), // 외관검사결과 등록화면(협력사)
      GoRoute(
        path: RoutePath.QIS012.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const QIS012(key: Key('QIS012')))), // 검사기준서화면
      GoRoute(
        path: RoutePath.CameraView.path,
        pageBuilder: TransionFactory.getSlidePageBuilder(
          child: const CameraView(key: Key('CameraView')))), // 카메라 촬영 뷰
    ];
  }
}