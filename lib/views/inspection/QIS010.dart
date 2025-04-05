// 외관검사결과 등록화면(서연이화)
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_manager/components/form/button.dart';
import 'package:product_manager/components/form/checkbox.dart';
import 'package:product_manager/components/form/radio.dart';
import 'package:product_manager/components/form/text_field.dart';
import 'package:product_manager/components/image/svg_image.dart';
import 'package:product_manager/components/layout/scaffold.dart';
import 'package:product_manager/components/modal/modal_dialog.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/file_type.dart';
import 'package:product_manager/constants/font_style.dart';
import 'package:product_manager/core/application_data.dart';
import 'package:product_manager/core/provider/login_notifier.dart';
import 'package:product_manager/core/router/route_path.dart';
import 'package:product_manager/models/inspection/inspection_type.dart';

class TabItem {
  final String code;
  final String title;
  bool isSelected;

  TabItem({
    required this.code,
    required this.title,
    this.isSelected = false
  });
}

class QIS010 extends ConsumerStatefulWidget {
  const QIS010({super.key});

  @override
  ConsumerState<QIS010> createState() => _QIS010State();
}

class _QIS010State extends ConsumerState<QIS010> {
  //-------------------------------------
  // VARIABLE
  //-------------------------------------
  late ScrollController scrollController;
  late ScrollController pictureScrollController;
  late TextEditingController writingDateController;
  late TextEditingController chargerController;
  late TextEditingController dateController;
  late TextEditingController actionResultController;
  late FocusNode actionResultNode;

  late List<TabItem> inspectionResultTabs;
  
  double _containerHeight = 100.0;
  bool _isCollapsed = false;
  
  bool isCheckInspection = false; // 검사기준서 확인여부
  DateTime selectedDate = DateTime.now(); // LOT NO 선택일자
  List<RadioType> checkProblems = [
    RadioType(
      id: 1,
      label: "QIS010.problemNo".tr(),
      value: "NO",
      isSelected: true
    ),
    RadioType(
      id: 1,
      label: "QIS010.problemYes".tr(),
      value: "YES",
      isSelected: false
    )
  ];

  final InspectionType _selectedInspection = InspectionType.create(
    id: 1,
    carType: "CN7",
    productName: "TRIM ASS'Y - FRT DRLH",
    dayInitialPictureCount: 4,
    dayMiddlePictureCount: 2,
    nightInitialPictureCount: 0,
    nightMiddlePictureCount: 1
  ); // 검사부품 정보

  final List<XFile> _pictureList = [];
  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  void initState() {
    scrollController = ScrollController();
    pictureScrollController = ScrollController();

    writingDateController = TextEditingController();
    writingDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    chargerController = TextEditingController();
    chargerController.text = "개똥이 / 2025033111";
    dateController = TextEditingController();
    actionResultController = TextEditingController();
    actionResultNode = FocusNode();

    inspectionResultTabs = [
      TabItem(
        code: "weekInitial",
        title: "QIS010.weekInitial".tr(),
        isSelected: true,
      ),
      TabItem(
        code: "weekMiddle",
        title: "QIS010.weekMiddle".tr(),
        isSelected: false,
      ),
      TabItem(
        code: "nightInitial",
        title: "QIS010.nightInitial".tr(),
        isSelected: false,
      ),
      TabItem(
        code: "nightMiddle",
        title: "QIS010.nightMiddle".tr(),
        isSelected: false,
      )
    ];

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    pictureScrollController.dispose();
    writingDateController.dispose();
    chargerController.dispose();
    dateController.dispose();
    actionResultController.dispose();
    
    super.dispose();
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
        infoText: "${"QIS008.ulsan".tr()}${"QIS008.factory".tr()} / ${DateFormat('yyyy-MM-dd').format(DateTime.now())} / ${"QIS008.day".tr()}",
        backwardButton: GestureDetector(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: SvgImage.asset(SvgImageAsset.icoBackwardArrow),
        ),
        title: "QIS008.title".tr(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildListItem(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: GestureDetector(
              onTap: () {
                _toggleHeight();
              },
              child: Container(
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: QisColors.gray100.color,
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: !_isCollapsed
                  ? SvgImage.asset(SvgImageAsset.icoArrowUp)
                  : SvgImage.sizedAsset(SvgImageAsset.icoSelectArrow, width: 24, height: 12)
              )
            )
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: CupertinoScrollbar(
              controller: scrollController,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: GestureDetector(
                          onTap: _gotoInspectionOrderView,
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              QisCheckbox(
                                onChanged: (_) {
                                  _gotoInspectionOrderView();
                                },
                                isChecked: isCheckInspection,
                                label: "QIS010.inspectionLabel".tr(),
                              ),
                              SvgImage.asset(SvgImageAsset.icoArrowRight)
                            ]
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: Text(
                          "QIS010.saveInspectionResult",
                          style: PretendardStyle.bold.copyWith(
                            fontSize: 16,
                            color: QisColors.gray900.color
                          )
                        ).tr()
                      ),
                      const SizedBox(height: 10),
                      // 작성일자
                      _buildTitle("QIS010.writingDate".tr()),
                      _buildContentBox(
                        content: UnderlineTextField(
                          controller: writingDateController,
                          readOnly: true,
                          style: PretendardStyle.regular.copyWith(
                            fontSize: 18,
                            color: QisColors.gray900.color
                          ),
                        )
                      ),
                      
                      const SizedBox(height: 20),
                      // 관리자
                      _buildTitle("QIS010.charger".tr()),
                      _buildContentBox(
                        content: UnderlineTextField(
                          controller: chargerController,
                          readOnly: true,
                          style: PretendardStyle.regular.copyWith(
                            fontSize: 18,
                            color: QisColors.gray900.color
                          ),
                        )
                      ),
                      const SizedBox(height: 30),
                      _buildContentBox(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _buildTabItems(),
                        )
                      ),
                      // LOT NO 설정
                      const SizedBox(height: 20),
                      _buildTitle("LOT NO"),
                      _buildContentBox(
                        content: CalendarTextField(
                          controller: dateController,
                          initialDate: selectedDate,
                          calendarTitle: "QIS010.configLotNo".tr(),
                          style: PretendardStyle.regular.copyWith(
                            fontSize: 18,
                            color: QisColors.gray900.color
                          ),
                        )
                      ),
                      const SizedBox(height: 20),
                      // 사진
                      _buildTitle("QIS010.picture".tr()),
                      const SizedBox(height: 10),
                      _buildContentBox(
                        content: SizedBox(
                          height: 100,
                          child: CupertinoScrollbar(
                            controller: pictureScrollController,
                            child: CustomScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: pictureScrollController,
                              slivers: [
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    _getPictureWidgets()
                                  )
                                )
                              ],
                            )
                          )
                        )
                      ),
                      const SizedBox(height: 20),
                      // 이상유무
                      _buildTitle("QIS010.checkProblem".tr()),
                      const SizedBox(height: 20),
                      _buildContentBox(
                        content: RadioGroup(
                          items: checkProblems,
                          onChanged: (RadioType item) {
                            setState(() {
                              for (RadioType radio in checkProblems) {
                                radio.isSelected = false;
                              }
                              item.isSelected = true;
                            });
                          }
                        )
                      ),
                      const SizedBox(height: 20),
                      // 조치결과
                      _buildTitle("QIS010.actionResult".tr()),
                      _buildContentBox(
                        content: UnderlineTextField(
                          controller: actionResultController,
                          focusNode: actionResultNode,
                          hintText: "QIS010.actionResultHint".tr(),
                          style: PretendardStyle.regular.copyWith(
                            fontSize: 18,
                            color: QisColors.gray900.color
                          ),
                        )
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
                        child: SimpleButton(
                          text: "common.save".tr(),
                          backgroundColor: QisColors.btnBlue.color,
                          textStyle: PretendardStyle.bold.copyWith(
                            fontSize: 16,
                            color: QisColors.white.color
                          ),
                          height: 60,
                          radius: 6,
                          onPressed: (){
                            GoRouter.of(context).pop();
                          }
                        )
                      )
                    ]),
                  )
                ],
              )
            )
          ),
        ]
      )
      
    );
  }

  //-------------------------------------
  // PRIVATE METHODS
  //-------------------------------------
  // 상단 검사기준서 높이 조절
  void _toggleHeight() {
    setState(() {
      _isCollapsed = !_isCollapsed;
      _containerHeight = _isCollapsed ? 0 : 100.0;
    });
  }

  // 검사기준서 화면 이동
  void _gotoInspectionOrderView() {
    

    ApplicationData.getInstance().inspectionCheckType = InspectionCheckType.create(
      fileUrl: "https://mobild-image-temp-bucket.s3.ap-northeast-2.amazonaws.com/beautiful_space_view-wallpaper-3840x2160.jpg",
      fileType: InspectionFileType.IMAGE,
      isChecked: false
    );
    
    GoRouter.of(context)
      .push<InspectionCheckType>(RoutePath.QIS012.path)
      .then((InspectionCheckType? result) {
        if(result != null) {
          setState(() {
            isCheckInspection = result.isChecked;
          });
        } else {
          setState(() {
            isCheckInspection = false;
          });
        }
      });
  }

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
  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Text(
        title,
        style: PretendardStyle.semibold.copyWith(
          fontSize: 16,
          color: QisColors.gray500.color
        )
      )
    );
  }

  Widget _buildContentBox({required Widget content}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: content
    );
  }

  /// 상단 검사대상 부품 정보
  Widget _buildListItem() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        height: _containerHeight,
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
                  _selectedInspection.carType,
                  style: PretendardStyle.bold.copyWith(
                    fontSize: 18,
                    color: QisColors.gray900.color
                  )
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedInspection.productName,
                  style: PretendardStyle.bold.copyWith(
                    fontSize: 18,
                    color: QisColors.gray900.color
                  )
                ),
              ],
            ),
            const SizedBox(height: 10),
            RichText(text: _getPictureCount(_selectedInspection)),
          ]
        )
      )
    );
  }

  /// 주간초품, 주간중품, 야간초품, 야간중품 탭
  List<Widget> _buildTabItems() {
    return inspectionResultTabs.map((item) {
      return Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () {
            setState(() {
              for (TabItem tab in inspectionResultTabs) {
                tab.isSelected = false;
              }

              item.isSelected = true;
            });
          },
          child: Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: item.isSelected
                  ? QisColors.btnBlue.color
                  : QisColors.gray100.color,
                  width: 3,
                  strokeAlign: BorderSide.strokeAlignInside
                )
              )
            ),
            child: Text(
              item.title,
              style: PretendardStyle.bold.copyWith(
                fontSize: 16,
                color: item.isSelected
                  ? QisColors.black.color
                  : QisColors.gray300.color
              )
            )
          )
        )
      );
    }).toList();
  }

  List<Widget> _getPictureWidgets() {
    List<Widget> widgets = [];

    int count = _selectedInspection.dayInitialPictureCount;

    for(int i = 0; i < count; i++) {
      if(i != 0) {
        widgets.add(const SizedBox(width: 10));
      }

      if(_pictureList.length > i) {
         widgets.add(_getPictureWidget(_pictureList[i]));
      } else {
        widgets.add(
          GestureDetector(
            onTap: () {
              // 사진 촬영 화면 이동
              GoRouter.of(context).push<XFile?>(RoutePath.CameraView.path).then((XFile? file) {
                if(file != null) {
                  _pictureList.add(file);
                  setState(() {});
                }
              });

            },
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: QisColors.white.color,
                borderRadius: BorderRadius.all(Radius.circular(6)),
                border: Border.all(
                  color: QisColors.gray300.color,
                  width: 1
                )
              ),
              child: SizedBox(
                width: 48,
                height: 48,
                child: SvgImage.asset(SvgImageAsset.icoEmptyPicture)
              )
            ),
          )
        );
      }
    }

    return widgets;
  }

  /// 촬영된 사진 위젯 만들기
  Widget _getPictureWidget(XFile file) {
    return GestureDetector(
      onTap: () {
        _showImageModal(file);
      },
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: QisColors.gray300.color,
              borderRadius: BorderRadius.all(Radius.circular(6)),
              border: Border.all(
                color: QisColors.transparent.color,
                width: 1
              )
            ),
            child: Image.file(File(file.path), fit: BoxFit.cover),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // 사진 삭제
                _pictureList.remove(file);
                setState(() {});
              },
              child: SvgIconButton(icon: SvgImageAsset.icoDelete)
            )
          )
        ],
      ),
    );
  }

  void _showImageModal(XFile file) {
    ModalDialog.show(
      context: context,
      child: Container(
        width: 320,
        height: 440,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: QisColors.white.color,
          borderRadius: BorderRadius.all(Radius.circular(6))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "QIS010.imageDetail",
              style: PretendardStyle.bold.copyWith(
                fontSize: 16,
                color: QisColors.gray900.color
              ),
            ).tr(),
            const SizedBox(height: 10),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                width: 296,
                decoration: BoxDecoration(
                  color: QisColors.black.color,
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(
                  File(file.path),
                  fit: BoxFit.contain,
                ),
              )
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SimpleButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: "common.cancel".tr(),
                  width: 145,
                  height: 48,
                  backgroundColor: QisColors.gray400.color,
                  textStyle: PretendardStyle.bold.copyWith(
                    fontSize: 14,
                    color: QisColors.white.color
                  )
                ),
                SimpleButton(
                  onPressed: () {
                    // 사진 삭제
                    _pictureList.remove(file);
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  text: "common.delete".tr(),
                  width: 145,
                  height: 48,
                  backgroundColor: QisColors.error.color,
                  textStyle: PretendardStyle.bold.copyWith(
                    fontSize: 14,
                    color: QisColors.white.color
                  )
                )
              ]
            )
          ]
        ),
      ),
    );
  }

  //-------------------------------------
  // EVENT HANDLERS
  //-------------------------------------
  void onChanged(bool value) {
    //
  }
}