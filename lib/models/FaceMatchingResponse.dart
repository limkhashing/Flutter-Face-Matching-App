// https://flutter.dev/docs/development/data-and-backend/json
// flutter pub run build_runner build - manual generate
// flutter pub run build_runner watch - auto generate by watches changes
import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'FaceMatchingResponse.g.dart';

@JsonSerializable()
class FaceMatchingResponse {
  @JsonKey(name: 'confidence', nullable: true)
  final double confidence;

  @JsonKey(name: 'face_found_in_image')
  final bool isFaceFoundInImage;

  @JsonKey(name: 'face_found_in_video')
  final bool isFaceFoundInVideo;

  @JsonKey(name: 'file_type', nullable: true)
  final String fileType;

  @JsonKey(name: 'is_match', nullable: true)
  final bool isMatch;

  @JsonKey(name: 'ocr_results', nullable: true)
  final List<String> ocrResults;

  FaceMatchingResponse(
    this.confidence,
    this.isFaceFoundInImage,
    this.isFaceFoundInVideo,
    this.fileType,
    this.isMatch,
    this.ocrResults,
  );

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory FaceMatchingResponse.fromJson(Map<String, dynamic> json) =>
      _$FaceMatchingResponseFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$FaceMatchingResponseToJson(this);

  /// Manual Serialization example
//  FaceMatchingResponse.fromJson(Map<String, dynamic> json)
//      : name = json['name'],
//        email = json['email'];
//
//  Map<String, dynamic> toJson() =>
//    {
//      'name': name,
//      'email': email,
//    };
}
