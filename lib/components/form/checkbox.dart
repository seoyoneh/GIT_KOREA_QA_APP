import 'package:flutter/cupertino.dart';
import 'package:product_manager/components/image/svg_image.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';

class QisCheckbox extends StatelessWidget {
  const QisCheckbox({
    super.key,
    this.isChecked = false,
    this.isDisabled = false,
    this.label = '',
    required this.onChanged,
  });

  final bool isChecked;
  final bool isDisabled;
  final String label;
  final Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isDisabled) {
          onChanged(!isChecked);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgImage.asset(
            isChecked && !isDisabled
            ? SvgImageAsset.icoCheckboxOn
            : SvgImageAsset.icoCheckboxOff
          ),
          label.isNotEmpty
          ? Container(
            margin: const EdgeInsets.only(left: 6),
            child: Text(
              label,
              style: PretendardStyle.semibold.copyWith(
                fontSize: 14,
                color: QisColors.gray900.color,
              )
            ),
          ) : Container()
        ],
      )
    );
  }
}