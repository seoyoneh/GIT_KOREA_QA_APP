// 검사기준서화면
import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:product_manager/components/form/button.dart';
import 'package:product_manager/components/form/checkbox.dart';
import 'package:product_manager/components/image/pinch_zoom_image_viewer.dart';
import 'package:product_manager/components/layout/scaffold.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/file_type.dart';
import 'package:product_manager/constants/font_style.dart';
import 'package:product_manager/core/application_data.dart';
import 'package:product_manager/models/inspection/inspection_type.dart';

class QIS012 extends StatefulWidget {
  const QIS012({super.key});

  @override
  State<QIS012> createState() => _QIS012State();
}

class _QIS012State extends State<QIS012> {
  //-------------------------------------
  // VARIABLE
  //-------------------------------------
  bool _inspectionCheck = false;
  String? _pdfFilePath;

  late InspectionCheckType _inspectionCheckType;

  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  void initState() {
    super.initState();

    if(ApplicationData.getInstance().inspectionCheckType != null) {
      _inspectionCheckType = ApplicationData.getInstance().inspectionCheckType!;
    }

    if(_inspectionCheckType.fileType == InspectionFileType.PDF) {
      _getPdfDocument(_inspectionCheckType.fileUrl).then((file) {
        setState(() {
          _pdfFilePath = file.path;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return QisScaffold(
      isSafeArea: true,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgIconButton(
                  icon: SvgImageAsset.icoArrowLeft,
                  size: const Size(36, 24),
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                ),
                Text(
                  "QIS012.title",
                  style: PretendardStyle.semibold.copyWith(
                    fontSize: 14,
                    color: QisColors.black.color,
                  )
                ).tr(),
                const SizedBox(width: 36),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: _inspectionCheckType.fileType == InspectionFileType.IMAGE
                  ? Container(
                      decoration: const BoxDecoration(),
                      clipBehavior: Clip.antiAlias,
                      alignment: Alignment.center,
                      child: PinchZoomImage(
                      imageUrl: _inspectionCheckType.fileUrl,
                      onClose: () {}
                    )
                  )
                  : _pdfFilePath == null
                    ? Container(
                      color: QisColors.transparent.color,
                      child: Center(child: CupertinoActivityIndicator(
                        color: QisColors.gray900.color,
                        radius: 15,
                      ))
                    )
                    : PDFView(
                        filePath: _pdfFilePath
                      )
            )
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: QisColors.gray300.color,
                  width: 1
                ),
                borderRadius: const BorderRadius.all(Radius.circular(6))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  QisCheckbox(
                    onChanged: (_) {
                      setState(() {
                        _inspectionCheck = !_inspectionCheck;
                      });
                    },
                    label: "QIS012.description".tr(),
                    isChecked: _inspectionCheck,
                  ),
                ]
              )
            )
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SimpleButton(
              backgroundColor: _inspectionCheck
                ? QisColors.btnBlue.color
                : QisColors.gray400.color,
              textStyle: PretendardStyle.bold.copyWith(
                fontSize: 18,
                color: QisColors.white.color
              ),
              height: 60,
              radius: 6,
              text: "common.confirm".tr(),
              onPressed: () {
                if (!_inspectionCheck) {
                  return;
                }

                _inspectionCheckType.isChecked = _inspectionCheck;
                GoRouter.of(context).pop(_inspectionCheckType);

              },
            )
          ),
          const SizedBox(height: 34),
        ],
      )
    );
  }

  //-------------------------------------
  // PRIVATE METHODS
  //-------------------------------------
  Future<File> _getPdfDocument(String url) async {
    Completer<File> completer = Completer();
    try {
      final url = "http://www.pdf995.com/samples/pdf.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();

      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch(e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
}