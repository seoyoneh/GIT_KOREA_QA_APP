import 'package:flutter/cupertino.dart';
import 'package:product_manager/components/image/svg_image.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';

/// 앱내에서 사용할 Scaffold 컴포넌트
class QisScaffold extends StatelessWidget {
  const QisScaffold({
    super.key,
    required this.child,
    this.isSafeArea = true,
    this.navigationBar,
    this.backgroundColor = const Color(0xFFFFFFFF),
  });

  final Widget child;
  final bool isSafeArea;
  final ObstructingPreferredSizeWidget? navigationBar;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: navigationBar,
      backgroundColor: backgroundColor,
      child: isSafeArea ? SafeArea(child: child) : child
    );
  }
}

class QisNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  const QisNavigationBar({
    super.key,
    required this.logo,
    required this.infoText,
    required this.title,
    this.topRightButton,
    this.backwardButton,
  });

  final SvgImageAsset logo; // 앱 로고
  final String infoText; // 페이지 정보
  final String title; // 페이지 제목
  final Widget? topRightButton; // 최상단 우측 버튼
  final Widget? backwardButton; // 뒤로가기 버튼

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgImage.asset(logo),
                topRightButton ?? Container()
              ]
            ),
          ),
          Container(
            color: QisColors.btnBlue.color,
            height: 60,
            alignment: Alignment.center,
            child: Text(
              infoText,
              style: PretendardStyle.bold.copyWith(
                fontSize: 16,
                color: QisColors.white.color
              ),
            )
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 12,
                  height: 24,
                  child: backwardButton ?? Container(),
                ),
                Flexible(
                  flex: 1,
                  child: Center(
                    child: Text(
                      title,
                      style: PretendardStyle.bold.copyWith(
                        fontSize: 14,
                        color: QisColors.black.color
                      )
                    )
                  )
                ),
                SizedBox(
                  width: 12,
                  height: 24,
                )
              ]
            )
          )
        ],
      )
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(150); // 네비게이션 높이(170)
  
  // 네비게이션의 배경을 투명 불투명 처리
  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}