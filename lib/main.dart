import 'package:product_manager/core/launcher.dart';
import 'package:product_manager/views/app.dart';

/// 앱 진입점
void main() async {
  await AppLauncher.run(const App());
}
