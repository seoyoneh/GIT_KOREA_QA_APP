import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:product_manager/components/form/button.dart';
import 'package:product_manager/components/layout/scaffold.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  //-------------------------------------
  // VARIABLE
  //-------------------------------------
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String? _errorMessage;

  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QisScaffold(
      backgroundColor: QisColors.black.color,
      child: Stack(
        children: [
          _errorMessage != null
          ? Center( // 에러 메시지 표시
              child: Text(
                _errorMessage!,
                style: TextStyle(color: CupertinoColors.systemRed),
              ),
            )
          : (_controller == null || !_controller!.value.isInitialized) // 카메라 표시
              ? Center(child: CupertinoActivityIndicator())
              : Stack(
                  children: [
                    Positioned.fill(
                      child: CameraPreview(_controller!),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgIconButton(
                            onPressed: _takePicture,
                            icon: SvgImageAsset.icoCameraShutter,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          Positioned(
            top: 20,
            right: 20,
            child: SvgIconButton(
              icon: SvgImageAsset.icoClose,
              onPressed: () {
                GoRouter.of(context).pop();
              },
            ),
          )
        ]
      )
    );
  }

  //-------------------------------------
  // PRIVATE METHODS
  //-------------------------------------
  Future<void> _initializeCamera() async {
    try {
      // 사용 가능한 카메라 목록을 가져옵니다.
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _errorMessage = '사용 가능한 카메라가 없습니다.';
        });
        return;
      }

      // 첫 번째 카메라를 선택하여 컨트롤러를 생성합니다.
      _controller = CameraController(
        _cameras.first,
        ResolutionPreset.high,
      );

      // 컨트롤러를 초기화합니다.
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;

      // 상태를 갱신하여 UI를 다시 빌드합니다.
      setState(() {});
    } catch (e) {
      setState(() {
        _errorMessage = '카메라 초기화 오류: $e';
      });
    }
  }

  Future<void> _takePicture() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        return;
      }
      
      final XFile image = await _controller!.takePicture();
      if(mounted) {
        GoRouter.of(context).pop(image); // 사진 촬영 후 경로 반환
      }
    } catch (e) {
      // 에러 처리
      setState(() {
        _errorMessage = '사진 촬영 오류';
      });
    }
  }
}