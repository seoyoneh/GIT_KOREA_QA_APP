import 'package:product_manager/constants/file_type.dart';

class InspectionType {
  final int id;
  final String carType; // 차종
  final String productName; // 제품명
  final int dayInitialPictureCount; // 주간 초품 사진 개수
  final int dayMiddlePictureCount; // 주간 중품 사진 개수
  final int nightInitialPictureCount; // 야간 초품 사진 개수
  final int nightMiddlePictureCount; // 야간 중품 사진 개수

  InspectionType.create({
    required this.id,
    required this.carType,
    required this.productName,
    required this.dayInitialPictureCount,
    required this.dayMiddlePictureCount,
    required this.nightInitialPictureCount,
    required this.nightMiddlePictureCount
  });
}

class InspectionCheckType {
  final String fileUrl;
  final InspectionFileType fileType;
  bool isChecked;

  InspectionCheckType.create({
    required this.fileUrl,
    required this.fileType,
    this.isChecked = false
  });
}