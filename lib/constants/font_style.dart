import 'package:flutter/cupertino.dart';

enum PretendardStyle {
  regular(textStyle: TextStyle(
    fontSize: 14,
    color: Color(0xFF000000),
    fontFamily: "Pretendard",
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
    height: 1.2,
  )),
  medium(textStyle: TextStyle(
    fontSize: 14,
    color: Color(0xFF000000),
    fontFamily: "Pretendard",
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
    height: 1.2,
  )),
  semibold(textStyle: TextStyle(
    fontSize: 14,
    color: Color(0xFF000000),
    fontFamily: "Pretendard",
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.2,)
  ),
  bold(textStyle: TextStyle(
    fontSize: 14,
    color: Color(0xFF000000),
    fontFamily: "Pretendard",
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  ))
  ;

  const PretendardStyle({
    required this.textStyle
  });

  final TextStyle textStyle;

  /// 폰트 스타일 복사
  TextStyle copyWith({
    bool? inherit,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    List<FontVariation>? fontVariations,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
  }) {
    return textStyle.copyWith(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
      overflow: overflow,
    );
  }
}