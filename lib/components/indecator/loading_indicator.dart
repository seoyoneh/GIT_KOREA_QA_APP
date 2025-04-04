import 'package:flutter/cupertino.dart';
import 'package:product_manager/constants/colors.dart';

class LoadingIndicator {
  static bool _showLoading = false;

  static void show(BuildContext context) {
    if (context.mounted) {
      _showLoading = true;
      showGeneralDialog(
          barrierColor: QisColors.transparent.color,
          barrierDismissible: false,
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: const Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
            );
          },
          transitionDuration: const Duration(microseconds: 300),
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {
            return const CupertinoActivityIndicator();
          });
    }
  }

  static void close(BuildContext context) {
    if (_showLoading && context.mounted) {
      _showLoading = false;
      Navigator.of(context).pop();
    }
  }
}
