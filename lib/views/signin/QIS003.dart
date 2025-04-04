// 사용자 유형 선택 화면
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:product_manager/components/layout/scaffold.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';
import 'package:product_manager/constants/user_type.dart';
import 'package:product_manager/core/application_data.dart';
import 'package:product_manager/core/router/route_path.dart';

class QIS003 extends StatefulWidget {
  const QIS003({super.key});

  @override
  State<QIS003> createState() => _QIS003State();
}

class _QIS003State extends State<QIS003> {
  @override
  Widget build(BuildContext context) {
    return QisScaffold(
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [            
              const SizedBox(height: 20),
              Flexible(
                flex: 1,
                child: _buildButton(
                  title: "QIS003.hqCompany".tr(),
                  description: "QIS003.hqComment".tr(),
                  imagePath: 'assets/images/bg/bg_hq.png',
                  onPressed: () {
                    ApplicationData.getInstance().userType = UserType.HQ;
                    GoRouter.of(context).push(RoutePath.QIS004.path);
                  }
                )
              ),
              const SizedBox(height: 20),
              Flexible(
                flex: 1,
                child: _buildButton(
                  title: "QIS003.partner".tr(),
                  description: "QIS003.partnerComment".tr(),
                  imagePath: 'assets/images/bg/bg_partner.png',
                  onPressed: () {
                    ApplicationData.getInstance().userType = UserType.PARTNER;
                    GoRouter.of(context).push(RoutePath.QIS005.path);
                  }
                )
              ),
              const SizedBox(height: 20),
            ]
          )
        )
      )
    );
  }

  //-------------------------------------
  // PRIVATE METHODS
  //-------------------------------------
  Widget _buildButton({
    required String title,
    required String description,
    required String imagePath,
    required VoidCallback onPressed
  }) {
    double buttonWidth = 320;

    return Container(
      constraints: BoxConstraints(
        maxWidth: buttonWidth,
        maxHeight: 320,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    width: buttonWidth - 24,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: PretendardStyle.bold.textStyle.copyWith(
                            fontSize: 20,
                            color: QisColors.white.color
                          )
                        ),
                        const SizedBox(height: 15),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style: PretendardStyle.regular.textStyle.copyWith(
                            fontSize: 16,
                            color: QisColors.white.color
                          )
                        ),
                      ]
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: buttonWidth,
                    color: QisColors.btnBlue.color,
                    padding: const EdgeInsets.fromLTRB(0, 15.5, 0, 15.5),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "common.choose".tr(),
                        style: PretendardStyle.bold.textStyle.copyWith(
                          fontSize: 14,
                          color: QisColors.white.color
                        )
                      )
                    )
                  )
                ],
              )
            )
          ],
        )
      )
    );
  }
}