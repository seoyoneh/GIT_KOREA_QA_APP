// 앱 권한 확인 페이지
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:product_manager/components/form/button.dart';
import 'package:product_manager/components/image/svg_image.dart';
import 'package:product_manager/components/layout/scaffold.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';
import 'package:product_manager/core/router/route_path.dart';

class QIS002 extends StatefulWidget {
  const QIS002({super.key});

  @override
  State<QIS002> createState() => _QIS002State();
}

class _QIS002State extends State<QIS002> {
  //-------------------------------------
  // VARIABLES
  //-------------------------------------
  late ScrollController _scrollController;
  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return QisScaffold(
      isSafeArea: false,
      child: Stack(
        children: [
          Container(
            color: QisColors.barrier.color,
            child: Center(
              child: Container(
                width: 320,
                height: 420,
                padding: const EdgeInsets.fromLTRB(21, 30, 20, 18),
                decoration: BoxDecoration(
                  color: QisColors.white.color,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "QIS002.title",
                        style: PretendardStyle.bold.textStyle.copyWith(
                          fontSize: 16,
                          color: QisColors.black.color
                        )
                      ).tr(),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        "QIS002.description",
                        textAlign: TextAlign.center,
                        style: PretendardStyle.regular.textStyle.copyWith(
                          fontSize: 14,
                          color: QisColors.black.color
                        )
                      ).tr(),
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      flex: 1,
                      child: CupertinoScrollbar(
                        controller: _scrollController,
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    decoration: BoxDecoration(
                                      color: QisColors.gray100.color,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SvgImage.asset(SvgImageAsset.icoCamera),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "QIS002.cameraRequired",
                                              style: PretendardStyle.bold.textStyle.copyWith(
                                                fontSize: 14,
                                                color: QisColors.black.color
                                              )
                                            ).tr(),
                                            const SizedBox(height: 11),
                                            SizedBox(
                                              width: mediaWidth - 207,
                                              child: Text(
                                                "QIS002.cameraDescription",
                                                maxLines: 3,
                                                style: PretendardStyle.regular.textStyle.copyWith(
                                                  fontSize: 14,
                                                  color: QisColors.black.color
                                                )
                                              ).tr(),
                                            )
                                          ]
                                        ),
                                      ],
                                    )
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "QIS002.permissionChangeMethod",
                                    style: PretendardStyle.regular.textStyle.copyWith(
                                      fontSize: 14,
                                      color: QisColors.black.color
                                    )
                                  ).tr(),
                                  const SizedBox(height: 6),
                                  Text(
                                    "QIS002.permissionChangeMethodDescription",
                                    style: PretendardStyle.regular.textStyle.copyWith(
                                      fontSize: 14,
                                      color: QisColors.gray500.color
                                    )
                                  ).tr(),
                                  const SizedBox(height: 17),
                                  Center(
                                    child: Text(
                                      "QIS002.permissionMessage",
                                      textAlign: TextAlign.center,
                                      style: PretendardStyle.bold.textStyle.copyWith(
                                        fontSize: 14,
                                        color: QisColors.black.color
                                      )
                                    ).tr(),
                                  ),
                                ]                                
                              )
                            )
                          ],
                        )
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SimpleButton(
                        text: "common.confirm".tr(),
                        textStyle: PretendardStyle.bold.textStyle.copyWith(
                          fontSize: 14,
                          color: QisColors.white.color
                        ),
                        backgroundColor: QisColors.btnBlue.color,
                        width: 280,
                        height: 48,
                        radius: 6,
                        onPressed: _onConfirmPressed)
                    ),
                  ],
                )
              ),
            ),
          )
        ],
      ),
    );
  }

  //-------------------------------------
  // PRIVATE METHODS
  //-------------------------------------
  /// 권한확인
  Future<Map<Permission, PermissionStatus>> _checkPermissions() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.photos,
      Permission.camera
    ].request();

    return permissions;
  }

  /// 권한 확인 후 이동
  void _confirmPermission() async {
    Map<Permission, PermissionStatus> permissions = await _checkPermissions();

    PermissionStatus photosStatus = permissions[Permission.photos]!;
    PermissionStatus cameraStatus = permissions[Permission.camera]!;

    if(photosStatus.isPermanentlyDenied ||
       cameraStatus.isPermanentlyDenied
    ) {
      openAppSettings();
    } else {
      if(mounted) {
        GoRouter.of(context).go(RoutePath.landing.path);
      }
    }
  }
  //-------------------------------------
  // EVENT HANDLERS
  //-------------------------------------
  /// 확인 버튼 클릭 이벤트 핸들러
  void _onConfirmPressed() {
    _confirmPermission();
  }
}