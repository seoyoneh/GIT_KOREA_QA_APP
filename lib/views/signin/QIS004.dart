// 서연이화 사용자 로그인 화면
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_manager/components/form/button.dart';
import 'package:product_manager/components/form/text_field.dart';
import 'package:product_manager/components/image/svg_image.dart';
import 'package:product_manager/components/layout/scaffold.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';
import 'package:product_manager/core/application_data.dart';
import 'package:product_manager/core/provider/login_notifier.dart';
import 'package:product_manager/models/login/token_type.dart';
import 'package:product_manager/services/login/login_service.dart';

class QIS004 extends ConsumerStatefulWidget {
  const QIS004({super.key});

  @override
  ConsumerState<QIS004> createState() => _QIS004State();
}

class _QIS004State extends ConsumerState<QIS004> {
  //-------------------------------------
  // VARIABLE
  //-------------------------------------
  late TextEditingController _idController;
  late FocusNode _idFocusNode;
  late TextEditingController _passwordController;
  late FocusNode _passwordFocusNode;

  late ScrollController _scrollController;
  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  void initState() {
    _idController = TextEditingController();
    _idFocusNode = FocusNode();
    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();

    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _idController.dispose();
    _idFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QisScaffold(
      child: CupertinoScrollbar(
        controller: _scrollController,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 110, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgImage.asset(SvgImageAsset.signinTitle),
                      const SizedBox(height: 11),
                      Text(
                        "QIS004.title",
                        style: PretendardStyle.medium.copyWith(
                          fontSize: 16,
                          color: QisColors.black.color
                        ),
                      ).tr(),
                      const SizedBox(height: 96),
                      UnderlineTextField(
                        controller: _idController,
                        focusNode: _idFocusNode,
                        hintText: "QIS004.id".tr(),
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      UnderlineTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        hintText: "QIS004.password".tr(),
                        isPassword: true,
                      ),
                      const SizedBox(height: 40),
                      SimpleButton(
                        text: "QIS004.login".tr(),
                        backgroundColor: QisColors.btnBlue.color,
                        height: 60,
                        radius: 6,
                        textStyle: PretendardStyle.bold.copyWith(
                          fontSize: 16,
                          color: QisColors.white.color
                        ),
                        onPressed: () {
                          // GoRouter.of(context).go(RoutePath.QIS006.path);
                          _getUserToken();
                        }),
                        const SizedBox(height: 10),
                        SimpleButton(
                        text: "common.backward".tr(),
                        backgroundColor: QisColors.gray400.color,
                        height: 48,
                        radius: 6,
                        textStyle: PretendardStyle.bold.copyWith(
                          fontSize: 16,
                          color: QisColors.white.color
                        ),
                        onPressed: () {
                          GoRouter.of(context).pop();
                          // _getUserToken();
                        }),
                      ]
                    )
                  )
              ]),
            )
          ]
        )
      )
    );
  }

  //-------------------------------------
  // PRIVATE METHODS : HTTP
  //-------------------------------------
  bool _isValid() {
    if (_idController.text.isEmpty) {
      _idFocusNode.requestFocus();
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _passwordFocusNode.requestFocus();
      return false;
    }
    return true;
  }

  /// 로그인 API 호출
  Future<void> _getUserToken() async {
    if(!_isValid()) {
      return;
    }

    LoginService service = LoginService.getInstance();
    String username = _idController.text;
    String password = _passwordController.text;

    JWTTokenType? token = await service.login(
      context: context,
      username: username,
      password: password,
      langSet: "KO"
    );

    if(token != null) {
      ApplicationData.getInstance().userToken = token;
      
      if(mounted) {
        ref.read(loginProvider.notifier).login(); // 로그인
      }
    } else {
      // 로그인 실패

    }
  }
}