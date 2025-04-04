import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:product_manager/components/form/calendar.dart';
import 'package:product_manager/components/image/svg_image.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';

class UnderlineTextField extends StatefulWidget {
  const UnderlineTextField({
    super.key,
    required this.controller,
    this.inputType = TextInputType.text,
    this.style,
    this.hintStyle,
    this.isPassword = false,
    this.hasVisible = false,
    this.hasReset = false,
    this.isError = false,
    this.disabled = false,
    this.readOnly = false,
    this.hintText = '',
    this.errorText = '',
    this.maxLength,
    this.defaultBorderColor = const Color(0xFF9CA3AF),
    this.focusBorderColor = const Color(0xFF9CA3AF),
    this.disabledBorderColor = const Color(0xFFE0E0E0),
    this.errorBoardColor = const Color(0xFFEB5757),
    this.onChanged,
    this.onReset,
    this.focusNode,
    this.onFocustOut,
    this.prefixItem
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType inputType;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool isPassword;
  final bool hasVisible;
  final bool hasReset;
  final bool isError;
  final bool disabled;
  final bool readOnly;
  final String hintText;
  final String errorText;
  final int? maxLength;
  final Color defaultBorderColor;
  final Color focusBorderColor;
  final Color disabledBorderColor;
  final Color errorBoardColor;
  final SvgImageAsset? prefixItem;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onReset;
  final VoidCallback? onFocustOut;  

  @override
  State<UnderlineTextField> createState() => _UnderlineTextFieldState();
}

class _UnderlineTextFieldState extends State<UnderlineTextField> {
  //-------------------------------------
  // VARIABLES
  //-------------------------------------
  bool _isVisible = false;
  bool _hasFocus = false;

  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  void initState() {
    _isVisible = !widget.isPassword;

    if(widget.focusNode != null) {
      widget.focusNode!.addListener(() {
        setState(() {
          _hasFocus = widget.focusNode!.hasFocus;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _getBorderColor(),
            width: 1
          )
        )
      ),
      child: Row(
        children: [
          ...(widget.prefixItem != null ?
          [
            SvgImage.asset(widget.prefixItem!),
            const SizedBox(width: 10)
          ] : []),
          Expanded(
            child: CupertinoTextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              style: widget.style ?? PretendardStyle.regular.textStyle.copyWith(
                fontSize: 18,
                color: QisColors.gray900.color
              ),
              keyboardType: widget.inputType,
              obscureText: widget.isPassword && !_isVisible,
              maxLength: widget.maxLength,
              placeholder: widget.hintText,
              readOnly: widget.readOnly,
              enabled: !widget.disabled,
              placeholderStyle: widget.hintStyle ?? PretendardStyle.regular.copyWith(
                fontSize: 18,
                color: QisColors.gray400.color
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0,
                  style: BorderStyle.none
                )
              ),
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              onTapOutside: _onTapOutside,
            )
          )
        ]
      )
    );
  }

  //-------------------------------------
  // PRIVATE METHODS
  //-------------------------------------
  /// 텍스트 필드의 보더 색상을 반환합니다.
  Color _getBorderColor() {
    if (widget.disabled) {
      return widget.disabledBorderColor;
    }

    if (widget.isError) {
      return widget.errorBoardColor;
    }

    if (_hasFocus) {
      return widget.focusBorderColor;
    }

    return widget.defaultBorderColor;
  }

  //-------------------------------------
  // EVENT HANDLERS
  //-------------------------------------
  void _onTapOutside(PointerDownEvent event) {
    if(widget.focusNode != null) {
      widget.focusNode!.unfocus();
    }
  }
}

/// 텍스트 필드 위에 달력이 표시되는 위젯입니다.
class CalendarTextField extends StatefulWidget {
  const CalendarTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.style,
    this.hintStyle,
    this.calendarTitle = '',
    this.isError = false,
    this.disabled = false,
    this.hintText = '',
    this.errorText = '',
    this.defaultBorderColor = const Color(0xFF9CA3AF),
    this.focusBorderColor = const Color(0xFF9CA3AF),
    this.disabledBorderColor = const Color(0xFFE0E0E0),
    this.errorBoardColor = const Color(0xFFEB5757),
    required this.initialDate,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final String calendarTitle;
  final bool isError;
  final bool disabled;
  final String hintText;
  final String errorText;
  final Color defaultBorderColor;
  final Color focusBorderColor;
  final Color disabledBorderColor;
  final Color errorBoardColor;
  final DateTime initialDate;
  final ValueChanged<DateTime>? onChanged;

  @override
  State<CalendarTextField> createState() => _CalendarTextFieldState();
}

class _CalendarTextFieldState extends State<CalendarTextField>
  with TickerProviderStateMixin {
  //-------------------------------------
  // VARIABLES
  //-------------------------------------
  bool _hasFocus = false;
  late DateTime _selectedDate;
  late QisCalendarController _calendarController;

  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  void initState() {
    _calendarController = QisCalendarController();
    _selectedDate = widget.initialDate;
    widget.controller.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    
    if(widget.focusNode != null) {
      widget.focusNode!.addListener(() {
        setState(() {
          _hasFocus = widget.focusNode!.hasFocus;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _getBorderColor(),
            width: 1
          )
        )
      ),
      child: Row(
        children: [
          SvgImage.asset(SvgImageAsset.icoCalendar),
          const SizedBox(width: 10),
          Expanded(
            child: CupertinoTextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              onTap: () {
                QisOverlayCalendar.show(
                  context,
                  title: widget.calendarTitle,
                  controller: _calendarController,
                  initialDate: _selectedDate,
                  onSelectedDate: (DateTime date) {
                    setState(() {
                      _selectedDate = date;
                      widget.controller.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
                      widget.onChanged?.call(date);
                    });
                  }
                );
              },
              style: widget.style ?? PretendardStyle.regular.textStyle.copyWith(
                fontSize: 16,
                color: QisColors.black.color
              ),
              placeholder: widget.hintText,
              readOnly: true,
              enabled: !widget.disabled,
              placeholderStyle: widget.hintStyle ?? PretendardStyle.regular.copyWith(
                fontSize: 16,
                color: QisColors.gray400.color
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0,
                  style: BorderStyle.none
                )
              ),
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              onTapOutside: _onTapOutside,
            )
          )
        ]
      )
    );
  }

  //-------------------------------------
  // PRIVATE METHODS
  //-------------------------------------
  /// 텍스트 필드의 보더 색상을 반환합니다.
  Color _getBorderColor() {
    if (widget.disabled) {
      return widget.disabledBorderColor;
    }

    if (widget.isError) {
      return widget.errorBoardColor;
    }

    if (_hasFocus) {
      return widget.focusBorderColor;
    }

    return widget.defaultBorderColor;
  }

  //-------------------------------------
  // EVENT HANDLERS
  //-------------------------------------
  void _onTapOutside(PointerDownEvent event) {
    if(widget.focusNode != null) {
      widget.focusNode!.unfocus();
    }
  }
}