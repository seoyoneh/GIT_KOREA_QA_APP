import 'package:flutter/cupertino.dart';
import 'package:product_manager/components/form/button.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';

class RadioGroup extends StatefulWidget {
  const RadioGroup({
    super.key,
    required this.items,
    required this.onChanged,
    this.margin = 27,
  });

  final List<RadioType> items;
  final double margin;
  final Function(RadioType) onChanged;

  @override
  State<RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildRadioButtons()
    );
  }

  List<Widget> _buildRadioButtons() {
    List<Widget> result = [];

    for(int i = 0; i < widget.items.length; i++) {
      RadioType radioType = widget.items[i];

      if(i != 0) {
        result.add(SizedBox(width: widget.margin));
      }

      result.add(
        RadioButton(
          radioType: radioType,
          onPressed: (RadioType type) {
            setState(() {
              widget.onChanged(type);
            });
          }
        )
      );
    }

    return result;
  }
}

class RadioButton extends StatelessWidget {
  const RadioButton({
    super.key,
    required this.radioType,
    required this.onPressed,
  });

  final RadioType radioType;
  final Function(RadioType) onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onPressed(radioType);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgIconButton(
            icon: radioType.isSelected
            ? SvgImageAsset.icoRadioOn
            : SvgImageAsset.icoRadioOff,
            onPressed: () {
              onPressed(radioType);
            }
          ),
          const SizedBox(width: 2),
          Text(
            radioType.label,
            style: PretendardStyle.semibold.copyWith(
              fontSize: 16,
              color: QisColors.gray900.color
            )
          ),
        ]
      )
    );
  }
}

class RadioType {
  final int id;
  final dynamic value;
  final String label;
  bool isSelected;

  RadioType({
    required this.id,
    required this.value,
    required this.label,
    this.isSelected = false
  });
}