import 'package:flutter/cupertino.dart';
import 'package:product_manager/components/image/svg_image.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';
import 'package:product_manager/constants/ui.dart';
import 'package:product_manager/models/form/radio_button_type.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    super.key,
    required this.text,
    this.backgroundColor = CupertinoColors.transparent,
    this.borderColor = CupertinoColors.transparent,
    this.textStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xFF333333),
      fontFamily: "Pretendard",
      height: 1,
    ),
    this.padding = const EdgeInsets.all(0),
    this.width = double.infinity,
    this.height = 30,
    this.radius = 0,
    required this.onPressed
  });

  final String text;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsets padding;
  final double width;
  final double height;
  final double radius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            width: 1,
            color: borderColor
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: Text(
            text,
            style: textStyle
          ),
        ),
      ),
    );
  }
}


class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.text,
    this.textStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xFF00569B),
      fontFamily: "Pretendard",
      height: 1,
    ),
    required this.onPressed
  });

  final String text;
  final TextStyle? textStyle;
    final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: textStyle
      ),
    );
  }
}

class RadioButtons extends StatefulWidget {
  const RadioButtons({
    super.key,
    required this.radioButtons,
    this.direction = Direction.horizontal,
    this.controller
  });

  final Direction direction;
  final List<RadioButtonType> radioButtons;
  final RadioButtonController? controller;

  @override
  State<RadioButtons> createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  Widget build(BuildContext context) {
    return widget.direction == Direction.horizontal
      ? Row(
        children: _buildRadioButtons()
      )
      : Column(
        children: _buildRadioButtons()
      );
  }

  //-------------------------------------
  // PRIVATE METHOD
  //-------------------------------------
  List<Widget> _buildRadioButtons() {
    List<Widget> result = [];

    for(int i = 0; i < widget.radioButtons.length; i++) {
      result.add(_buildItem(widget.radioButtons[i]));

      if(i != widget.radioButtons.length - 1) {
        switch(widget.direction) {
          case Direction.horizontal:
            result.add(const SizedBox(width: 10));
            break;
          case Direction.vertical:
            result.add(const SizedBox(height: 10));
            break;
        }
      }
    }
    return result;
  }

  Widget _buildItem(RadioButtonType item) {
    return Flexible(
      flex: 1,
      child: SimpleButton(
        text: item.label,
        radius: 8,
        height: 40,
        textStyle: PretendardStyle.bold.copyWith(
          fontSize: 16,
          color: item.isSelected
            ? QisColors.white.color
            : QisColors.gray900.color
        ),
        backgroundColor: item.isSelected
          ? QisColors.blue100.color
          : QisColors.white.color,
        borderColor: item.isSelected
          ? CupertinoColors.transparent
          : QisColors.gray300.color,
        onPressed: () {
          if(widget.controller != null) {
            widget.controller!.select(item);
          }
        }
      ),
    );
  }
}

class RadioButtonController extends ChangeNotifier {
  //-------------------------------------
  // VARIABLE
  //-------------------------------------
  RadioButtonType? _selectedItem;

  //-------------------------------------
  // GETTER
  //-------------------------------------
  RadioButtonType? get selectedItem => _selectedItem;

  //-------------------------------------
  // PUBLIC METHOD
  //-------------------------------------
  void select(RadioButtonType item) {
    _selectedItem = item;
    notifyListeners();
  }
}

class SvgIconButton extends StatelessWidget {
  const SvgIconButton({
    super.key,
    required this.icon,
    this.size,
    this.onPressed
  });

  final SvgImageAsset icon;
  final Size? size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SvgImage.sizedAsset(
        icon,
        width: size?.width ?? icon.width,
        height: size?.height ?? icon.height,
      )
    );
  }
}