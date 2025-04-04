// 작업정보 입력화면(협력사)
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_manager/components/form/button.dart';
import 'package:product_manager/components/form/select.dart';
import 'package:product_manager/components/form/text_field.dart';
import 'package:product_manager/components/layout/scaffold.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';
import 'package:product_manager/core/provider/login_notifier.dart';
import 'package:product_manager/core/router/route_path.dart';
import 'package:product_manager/models/form/radio_button_type.dart';
import 'package:product_manager/models/form/select_type.dart';

class QIS007 extends ConsumerStatefulWidget {
  const QIS007({super.key});

  @override
  ConsumerState<QIS007> createState() => _QIS007State();
}

class _QIS007State extends ConsumerState<QIS007> {
  //-------------------------------------
  // VARIABLE
  //-------------------------------------
  late ScrollController _scrollController;

  late TextEditingController _userInfoController;
  late FocusNode _userInfoFocusNode;
  late TextEditingController _writingDateController;
  late FocusNode _writingDateFocusNode;

  final List<RadioButtonType> _businessTypeList = [
    RadioButtonType.create(id: 1, value: "ULSAN", label: "QIS007.ulsan".tr(), isSelected: true),
    RadioButtonType.create(id: 2, value: "ASAN", label: "QIS007.asan".tr()),
  ];
  late RadioButtonController _businessTypeController;

  final List<RadioButtonType> _workTypeList = [
    RadioButtonType.create(id: 1, value: "DAY", label: "QIS007.day".tr(), isSelected: true),
    RadioButtonType.create(id: 2, value: "NIGHT", label: "QIS007.night".tr()),
  ];
  late RadioButtonController _workTypeController;

  List<SelectType> _carTypeList = [];
  late RollUpSelectController _carTypeController;
  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  void initState() {
    _scrollController = ScrollController();

    _userInfoController = TextEditingController();
    _userInfoController.text = "개똥이/20250327";
    _userInfoFocusNode = FocusNode();
   
    _writingDateController = TextEditingController();
    _writingDateController.text = DateFormat('yyyy.MM.dd').format(DateTime.now());
    _writingDateFocusNode = FocusNode();

    _businessTypeController = RadioButtonController();
    _businessTypeController.addListener(() {
      _onSelectedRadioButton(
        _businessTypeController.selectedItem!,
        _businessTypeList
      );
    });

    _workTypeController = RadioButtonController();
    _workTypeController.addListener(() {
      _onSelectedRadioButton(
        _workTypeController.selectedItem!,
        _workTypeList
      );
    });

    _carTypeController = RollUpSelectController();
    _carTypeController.addListener(() {
      _onSelectedCarType(_carTypeController.selectedItem!);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCarType();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return QisScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Column(
              children:[
                Container(
                  color: QisColors.btnBlue.color,
                  height: 115,
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "QIS007.title",
                        style: PretendardStyle.bold.copyWith(
                          fontSize: 16,
                          color: QisColors.white.color
                        )
                      ).tr(),
                      LinkButton(
                        text: "common.logout".tr(),
                        textStyle: PretendardStyle.regular.copyWith(
                          fontSize: 14,
                          color: QisColors.white.color
                        ),
                        onPressed: (){
                          ref.read(loginProvider.notifier).logout();
                        })
                    ]
                  )
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: CupertinoScrollbar(
                    controller: _scrollController,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Container(
                                padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "QIS007.partnerName",
                                      textAlign: TextAlign.left,
                                      style: PretendardStyle.medium.copyWith(
                                        fontSize: 16,
                                        color: QisColors.gray500.color
                                      )
                                    ).tr(),
                                    UnderlineTextField(
                                      controller: _userInfoController,
                                      focusNode: _userInfoFocusNode,
                                      style: PretendardStyle.regular.copyWith(
                                        fontSize: 18,
                                        color: QisColors.gray900.color
                                      ),
                                      readOnly: true,
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      "QIS007.businessType",
                                      textAlign: TextAlign.left,
                                      style: PretendardStyle.medium.copyWith(
                                        fontSize: 16,
                                        color: QisColors.gray500.color
                                      )
                                    ).tr(),
                                    const SizedBox(height: 10),
                                    RadioButtons(
                                      radioButtons: _businessTypeList,
                                      controller: _businessTypeController,
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      "QIS007.writingDate",
                                      textAlign: TextAlign.left,
                                      style: PretendardStyle.medium.copyWith(
                                        fontSize: 16,
                                        color: QisColors.gray500.color
                                      )
                                    ).tr(),
                                    UnderlineTextField(
                                      controller: _writingDateController,
                                      focusNode: _writingDateFocusNode,
                                      style: PretendardStyle.regular.copyWith(
                                        fontSize: 18,
                                        color: QisColors.gray900.color
                                      ),
                                      prefixItem: SvgImageAsset.icoCalendar,
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      "QIS007.workType",
                                      textAlign: TextAlign.left,
                                      style: PretendardStyle.medium.copyWith(
                                        fontSize: 16,
                                        color: QisColors.gray500.color
                                      )
                                    ).tr(),
                                    const SizedBox(height: 10),
                                    RadioButtons(
                                      radioButtons: _workTypeList,
                                      controller: _workTypeController,
                                    ),
                                  ]
                                ),  
                              ),
                              const SizedBox(height: 15),
                            ]
                          )
                        )
                      ]
                    )
                  )
                )
              ]
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SimpleButton(
              text: "common.connect".tr(),
              backgroundColor: QisColors.btnBlue.color,
              textStyle: PretendardStyle.bold.copyWith(
                fontSize: 18,
                color: QisColors.white.color
              ),
              height: 60,
              radius: 6,
              onPressed: () {
                GoRouter.of(context).push(RoutePath.QIS009.path);
              }
            )
          ),
          const SizedBox(height: 20)
        ],
      )
    );
  }

  //-------------------------------------
  // PRIVATE METHODS
  //-------------------------------------
  Future<void> _getCarType() async {
    _carTypeList = [
      SelectType.create(id: 1, value: "ALL", label: "전체", isSelected: true),
      SelectType.create(id: 2, value: "CN7", label: "CN7"),
      SelectType.create(id: 3, value: "CN8", label: "CN8"),
      SelectType.create(id: 4, value: "CN8", label: "CN8"),
      SelectType.create(id: 5, value: "CN8", label: "CN8"),
      SelectType.create(id: 6, value: "CN8", label: "CN8"),
      SelectType.create(id: 7, value: "CN8", label: "CN8"),
      SelectType.create(id: 8, value: "CN8", label: "CN8"),
      SelectType.create(id: 9, value: "CN8", label: "CN8"),
      SelectType.create(id: 10, value: "CN8", label: "CN8"),
      SelectType.create(id: 11, value: "CN8", label: "CN8"),
    ];

    setState(() {});
  }
  //-------------------------------------
  // EVENT HANDLERS
  //-------------------------------------
  /// 라디오 버튼 선택 시
  void _onSelectedRadioButton(RadioButtonType selectedItem, List<RadioButtonType> list) {
    for(RadioButtonType item in list) {
      if(item.id != selectedItem.id) {
        item.isSelected = false;
      } else {
        item.isSelected = true;
      }
    }

    setState(() {});
  }

  void _onSelectedCarType(SelectType selectedItem) {
    for(SelectType item in _carTypeList) {
      if(item.id != selectedItem.id) {
        item.isSelected = false;
      } else {
        item.isSelected = true;
      }
    }

    setState(() {});
  }
}