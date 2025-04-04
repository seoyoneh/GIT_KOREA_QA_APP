// 외관검사결과 목록화면(협력사)
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_manager/components/form/button.dart';
import 'package:product_manager/components/image/svg_image.dart';
import 'package:product_manager/components/layout/scaffold.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';
import 'package:product_manager/core/provider/login_notifier.dart';
import 'package:product_manager/core/router/route_path.dart';
import 'package:product_manager/models/inspection/inspection_type.dart';

class QIS009 extends ConsumerStatefulWidget {
  const QIS009({super.key});

  @override
  ConsumerState<QIS009> createState() => _QIS009State();
}

class _QIS009State extends ConsumerState<QIS009> {
  //-------------------------------------
  // VARIABLE
  //-------------------------------------
  late ScrollController _scrollController;
  final List<InspectionType> _inspectionList = [];
  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  void initState() {
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getInspectionList();
    });

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {    
    return QisScaffold(
      isSafeArea: true,
      navigationBar: QisNavigationBar(
        logo: SvgImageAsset.contentLogo,
        topRightButton: LinkButton(
          text: "common.logout".tr(),
          textStyle: PretendardStyle.medium.copyWith(
            color: QisColors.gray900.color,
            fontSize: 14
          ),
          onPressed: (){
            ref.read(loginProvider.notifier).logout();
          }
        ),
        infoText: "한국전자 / ${"QIS009.ulsan".tr()}${"QIS009.factory".tr()} / ${DateFormat('yyyy-MM-dd').format(DateTime.now())} / ${"QIS009.day".tr()}",
        backwardButton: GestureDetector(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: SvgImage.asset(SvgImageAsset.icoBackwardArrow),
        ),
        title: "QIS009.title".tr(),
      ),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: CupertinoScrollbar(
              controller: _scrollController,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverList.builder(
                    itemCount: _inspectionList.length,
                    itemBuilder: _buildListItem
                  )
                ],
              )
            )
          )
        ]
      )
    );
  }

  //-------------------------------------
  // PRIVATE METHODS
  //-------------------------------------
  TextStyle _getTextStyleForPictureCount(int count) {
    return count > 0
    ? PretendardStyle.bold.copyWith(
      fontSize: 16,
      color: QisColors.black.color
    ) : PretendardStyle.regular.copyWith(
      fontSize: 16,
      color: QisColors.black.color
    );
  }

  TextSpan _getPictureCount(InspectionType inspection) {
    TextSpan result = TextSpan(
      children: [
        TextSpan(
          text : "${"QIS008.day".tr()} ${"QIS008.initial".tr()} ${inspection.dayInitialPictureCount}${"QIS008.unit".tr()} | ",
          style: _getTextStyleForPictureCount(inspection.dayInitialPictureCount)
        ),
        TextSpan(
          text : "${"QIS008.day".tr()} ${"QIS008.middle".tr()} ${inspection.dayMiddlePictureCount}${"QIS008.unit".tr()}\n",
          style: _getTextStyleForPictureCount(inspection.dayMiddlePictureCount)
        ),
        TextSpan(
          text : "${"QIS008.night".tr()} ${"QIS008.initial".tr()} ${inspection.nightInitialPictureCount}${"QIS008.unit".tr()} | ",
          style: _getTextStyleForPictureCount(inspection.nightInitialPictureCount)
        ),
        TextSpan(
          text : "${"QIS008.night".tr()} ${"QIS008.middle".tr()} ${inspection.nightMiddlePictureCount}${"QIS008.unit".tr()}",
          style: _getTextStyleForPictureCount(inspection.nightMiddlePictureCount)
        ),
      ]
    );

    return result;
  }
  //-------------------------------------
  // PRIVATE METHODS : BUILDER
  //-------------------------------------
  Widget _buildListItem(BuildContext context, int index) {
    final InspectionType inspection = _inspectionList[index];

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).push(RoutePath.QIS011.path);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(21, 12, 21, 12),
          decoration: BoxDecoration(
            color: QisColors.gray100.color,
            borderRadius: BorderRadius.all(Radius.circular(6))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    inspection.carType,
                    style: PretendardStyle.bold.copyWith(
                      fontSize: 18,
                      color: QisColors.gray900.color
                    )
                  ),
                  const SizedBox(width: 12),
                  Text(
                    inspection.productName,
                    style: PretendardStyle.bold.copyWith(
                      fontSize: 18,
                      color: QisColors.gray900.color
                    )
                  ),
                ],
              ),
              const SizedBox(height: 10),
              RichText(text: _getPictureCount(inspection)),
            ]
          )
        )
      )
    );
  }
  //-------------------------------------
  // PRIVATE METHODS : HTTP
  //-------------------------------------
  Future<void> _getInspectionList() async {
    _inspectionList.clear();
    _inspectionList.addAll([
      InspectionType.create(
        id: 1,
        carType: "CN7",
        productName: "TRIM ASS'Y - FRT DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
      InspectionType.create(
        id: 2,
        carType: "CN8",
        productName: "TRIM ASS'Y - FRT DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
      InspectionType.create(
        id: 3,
        carType: "CN9",
        productName: "TRIM ASS'Y - FRT DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
      InspectionType.create(
        id: 4,
        carType: "CN6",
        productName: "TRIM ASS'Y - FRT DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
      InspectionType.create(
        id: 5,
        carType: "CN5",
        productName: "TRIM ASS'Y - FRT DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
      InspectionType.create(
        id: 6,
        carType: "CN4",
        productName: "TRIM ASS'Y - FRT DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
      InspectionType.create(
        id: 7,
        carType: "CN3",
        productName: "TRIM ASS'Y - FRT DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
      InspectionType.create(
        id: 8,
        carType: "CN2",
        productName: "TRIM ASS'Y - FRT DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
      InspectionType.create(
        id: 9,
        carType: "CN1",
        productName: "TRIM ASS'Y - FRT DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
      InspectionType.create(
        id: 10,
        carType: "CN2",
        productName: "TRIM ASS'Y - FRT DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
      InspectionType.create(
        id: 11,
        carType: "CN3",
        productName: "TRIM ASS'Y - FRT DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
      InspectionType.create(
        id: 12,
        carType: "CN4",
        productName: "TRIM ASS'Y - RER DRLH",
        dayInitialPictureCount: 3,
        dayMiddlePictureCount: 2,
        nightInitialPictureCount: 0,
        nightMiddlePictureCount: 1
      ),
    ]);

    setState(() {});
  }
}