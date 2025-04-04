import 'package:flutter/cupertino.dart';
import 'package:product_manager/constants/colors.dart';

class ModalDialogRoute extends PageRouteBuilder {
  ModalDialogRoute({
    required this.child,
  }) : super(
    /// 화면 전환 시, 배경을 투명하게 유지할지 여부
    opaque: false,
    /// 배경(배리어)을 눌러도 닫을 수 있게 하려면 true
    barrierDismissible: true,
    /// 모달 뒤에 깔리는 배리어 색상
    barrierColor: QisColors.barrier.color,
    /// 전환(등장/사라짐) 애니메이션 시간
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    /// 실제 보여줄 위젯을 빌드하는 콜백
    pageBuilder: (context, animation, secondaryAnimation) {
      return FadeTransition(
        opacity: animation,
        child: Center(
          child: child,
        ),
      );
    },
  );

  final Widget child;
}

class ModalDialog {
  static Future<void> show({
    required BuildContext context,
    required Widget child
  }) {
    return Navigator.of(context).push(
      ModalDialogRoute(child: child),
    );
  }
}