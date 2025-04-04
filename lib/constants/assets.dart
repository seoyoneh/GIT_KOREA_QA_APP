/// SVG 이미지 에셋 정의 코드
enum SvgImageAsset {
  companyIdentity(path: 'assets/images/ci_en.svg', width: 353, height: 44),
  contentLogo(path: 'assets/images/ci_en.svg', width: 124, height: 15),
  signinTitle(path: 'assets/images/ci_en.svg', width: 247, height: 30),
  icoCamera(path: 'assets/images/ico/ico_camera.svg', width: 24, height: 24),
  icoCalendar(path: 'assets/images/ico/ico_calendar.svg', width: 21, height: 21),
  icoSelectArrow(path: 'assets/images/ico/ico_select_arrow.svg', width: 12, height: 24),
  icoBackwardArrow(path: 'assets/images/ico/ico_backward_arrow.svg', width: 12, height: 24),
  icoRadioOn(path: 'assets/images/ico/ico_radio_on.svg', width: 24, height: 24),
  icoRadioOff(path: 'assets/images/ico/ico_radio_off.svg', width: 24, height: 24),
  icoCheckboxOn(path: 'assets/images/ico/ico_checkbox_on.svg', width: 24, height: 24),
  icoCheckboxOff(path: 'assets/images/ico/ico_checkbox_off.svg', width: 24, height: 24),
  icoArrowLeft(path: 'assets/images/ico/ico_calendar_arrow_left.svg', width: 12, height: 24),
  icoArrowRight(path: 'assets/images/ico/ico_calendar_arrow_right.svg', width: 12, height: 24),
  icoArrowUp(path: 'assets/images/ico/ico_arrow_up.svg', width: 24, height: 12),
  icoEmptyPicture(path: 'assets/images/ico/ico_empty_picture.svg', width: 48, height: 48),
  icoClose(path: 'assets/images/ico/ico_close.svg', width: 50, height: 50),
  icoCameraShutter(path: 'assets/images/ico/ico_camera_shutter.svg', width: 78, height: 78),
  icoDelete(path: 'assets/images/ico/ico_delete.svg', width: 38, height: 38),
  ;

  const SvgImageAsset({
    required this.path,
    required this.width,
    required this.height
  });

  final String path;
  final double width;
  final double height;
}