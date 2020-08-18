import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_face_matching_app/models/FaceMatchingResponse.dart';
import 'endpoint.dart';

class FaceMatchingAPI {
  String imagePath;
  String videoPath;
  Dio dio = Dio();

  FaceMatchingAPI(this.imagePath, this.videoPath);

  Future<FaceMatchingResponse> compareFace() async {
    print("Calling face matching api...");

    try {
      FormData formData = FormData.fromMap({
        "known": await MultipartFile.fromFile(imagePath),
        "unknown": await MultipartFile.fromFile(videoPath),
        "tolerance": 0.50, // default value
        "threshold": 0.80 // default value
      });

      Response dioResponse =
          await dio.post(FACE_MATCHING_URL, data: formData).timeout(Duration(seconds: 1000));
//      print(dioResponse.toString()); // dioResponse.data returns a map object

      Map compareResultMap = jsonDecode(dioResponse.toString());
      FaceMatchingResponse response =
          FaceMatchingResponse.fromJson(compareResultMap);
      return response;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
