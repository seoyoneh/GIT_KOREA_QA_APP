import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:product_manager/core/router/route_path.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  //-------------------------------------
  // IMPLEMENTS
  //-------------------------------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // #2. 권한을 취득한다.
      bool cameraGranted = await Permission.camera.isGranted; // 카메라 권한
      bool photoGranted = await Permission.photos.isGranted; // 갤러리 권한

      if((!cameraGranted || !photoGranted) && mounted) {
        GoRouter.of(context).go(RoutePath.QIS002.path);
        return;
      }

      if(mounted) {
        GoRouter.of(context).go(RoutePath.QIS003.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(80),
              child: Center(
                child: Column(
                  children: <Widget>[
                    // Image.asset('assets/images/app-icon-brand.png'),
                    // Padding(padding: const EdgeInsets.only(top: 20)),
                    CupertinoActivityIndicator(),
                  ],
                )
              )
            )
          ],
        ),
      ),
    );
  }
}