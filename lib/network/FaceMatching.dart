import 'package:dio/dio.dart';
import 'endpoint.dart';

class FaceMatching {
  String imagePath;
  String videoPath;

  FaceMatching(this.imagePath, this.videoPath);

  Future<void> compareFace() async {
    try {
      print(imagePath);
      print(videoPath);

      // TODO show a dialog when gotten result
      FormData formData = FormData.fromMap({
        "known": await MultipartFile.fromFile(imagePath),
        "unknown": await MultipartFile.fromFile(videoPath),
        "tolerance": 0.50, // default value
        "threshold": 0.80 // default value
      });
      Response response = await Dio().post(FACE_MATCHING_URL, data: formData);
      print(response.data.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
