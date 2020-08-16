// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FaceMatchingResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaceMatchingResponse _$FaceMatchingResponseFromJson(Map<String, dynamic> json) {
  return FaceMatchingResponse(
    (json['confidence'] as num)?.toDouble(),
    json['face_found_in_image'] as bool,
    json['face_found_in_video'] as bool,
    json['file_type'] as String,
    json['is_match'] as bool,
    (json['ocr_results'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$FaceMatchingResponseToJson(
        FaceMatchingResponse instance) =>
    <String, dynamic>{
      'confidence': instance.confidence,
      'face_found_in_image': instance.isFaceFoundInImage,
      'face_found_in_video': instance.isFaceFoundInVideo,
      'file_type': instance.fileType,
      'is_match': instance.isMatch,
      'ocr_results': instance.ocrResults,
    };
