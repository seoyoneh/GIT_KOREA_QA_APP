import 'package:flutter/cupertino.dart';
import 'package:product_manager/constants/colors.dart';

/// 핀치 줌 이미지 위젯
class PinchZoomImage extends StatefulWidget {
  const PinchZoomImage({
    super.key,
    required this.imageUrl,
    required this.onClose
  });
  
  final VoidCallback onClose;
  final String imageUrl;

  @override
  State<PinchZoomImage> createState() => _PinchZoomImageState();
}

class _PinchZoomImageState extends State<PinchZoomImage> with TickerProviderStateMixin{
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  late Animation<Offset> _positionAnimation;

  double _scale = 1.0; // 현재 스케일
  double _previousScale = 1.0;
  Offset _position = Offset.zero; // 현재 이미지 위치
  Offset _previousPosition = Offset.zero;
  Offset _focalPoint = Offset.zero; // 손가락 중심 위치

  late double _imageWidth; // 기본 너비
  late double _imageHeight; // 기본 높이
  late Size _screenSize; // 디바이스 크기

  @override
  void initState() {
    // 줌 애니메이션
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _zoomAnimation = Tween<double>(begin: _scale, end: 1.0).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeOutCubic),
    );

    _zoomAnimation.addListener(() {
      setState(() {
        _scale = _zoomAnimation.value;
        _position = _positionAnimation.value;
      });
    });

    _positionAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeOutCubic),
    );

    super.initState();
  }

  @override
  void dispose() {
    _zoomController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    _imageWidth = _screenSize.width;
    _imageHeight = _imageWidth * (2 / 3); // 3:2 비율 유지
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _previousScale = _scale;
        _previousPosition = _position;
        _focalPoint = details.focalPoint;
      },
      onScaleUpdate: (details) {
        setState(() {
          double newScale = (_previousScale * details.scale).clamp(1.0, 4.0);

          Offset delta = details.focalPoint - _focalPoint;
          Offset newPosition = _previousPosition + delta;

          // 이동 제한 (확대 시만 이동 가능)
          double boundX = (_imageWidth * (newScale - 1)) / 2;
          double boundY = (_imageHeight * (newScale - 1)) / 2;

          _scale = newScale;
          _position = Offset(
            newPosition.dx.clamp(-boundX, boundX),
            newPosition.dy.clamp(-boundY, boundY),
          );
        });
      },
      onDoubleTap: _handleDoubleTap,
      child: Container(
        color: QisColors.white.color,
        alignment: Alignment.center,
        child: ClipRect(
          clipBehavior: Clip.none,
          child: AnimatedBuilder(
            animation: _zoomAnimation,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(_position.dx, _position.dy)
                  ..scale(_scale, _scale, 1),
                child: Image.network(
                  widget.imageUrl,
                  width: _imageWidth,
                  height: _imageHeight,
                  fit: BoxFit.cover,
                  loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Container(
                        color: QisColors.transparent.color,
                        child: Center(child: CupertinoActivityIndicator(
                          color: QisColors.gray900.color,
                          radius: 15,
                        ))
                      );
                    }
                  }
                ),
              );
            }
          )
        ),
      ),
    );
  }

  //-------------------------------------
  // EVENT HANDLERS
  //-------------------------------------
  void _handleDoubleTap() {
    double targetScale = (_scale == 1.0) ? 2.0 : 1.0; // 목표 배율 결정
    Offset targetPosition = (_scale == 1.0) ? _position : Offset.zero; // 목표 위치 결정

    // 현재 스케일 값을 기반으로 새로운 Tween을 설정하여 애니메이션 적용
    _zoomAnimation = Tween<double>(begin: _scale, end: targetScale).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeOutCubic),
    );

    _positionAnimation = Tween<Offset>(begin: _position, end: targetPosition).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeOutCubic),
    );

    _zoomController.reset();
    _zoomController.forward().then((_) {
      // 줌아웃 완료 후 위치 초기화
      if (targetScale == 1.0) {
        setState(() {
          _position = Offset.zero;
        });
      }
    });
  }
}