import 'package:flutter/cupertino.dart';

enum QisColors {
  transparent(Color(0x00000000)),
  white(Color(0xFFFFFFFF)),
  black(Color(0xFF000000)),
  gray100(Color(0xFFF3F4F6)),
  gray300(Color(0xFFD1D5DB)),
  gray400(Color(0xFF9CA3AF)),
  gray500(Color(0xFF6B7280)),
  gray700(Color(0xFF374151)),
  gray900(Color(0xFF111827)),
  blue100(Color(0xFF0065FF)),
  btnBlue(Color(0xFF00569B)),
  weekBlue(Color(0xFF17A1FA)),
  error(Color(0xFFCE3426)),
  barrier(Color(0x7F000000)),
  today(Color(0xFFED9C04)),
  ;

  final Color _color;

  Color get color => _color;

  const QisColors(this._color);
}