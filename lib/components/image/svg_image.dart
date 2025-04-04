import 'package:flutter_svg/svg.dart';
import 'package:product_manager/constants/assets.dart';

class SvgImage {
  /// SVG 이미지를 가져온다.
  static SvgPicture asset(SvgImageAsset asset) {
    return SvgPicture.asset(
      asset.path,
      width: asset.width,
      height: asset.height,
    );
  }
  static SvgPicture sizedAsset(SvgImageAsset asset, {double? width, double? height}) {
    return SvgPicture.asset(
      asset.path,
      width: width ?? asset.width,
      height: height ?? asset.height,
    );
  }
}