import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';

String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

CameraDescription getCameraLensDirection(CameraLensDirection direction, List<CameraDescription> cameras) {
  switch (direction) {
    case CameraLensDirection.back:
      return cameras.first;
    case CameraLensDirection.front:
      return cameras[1];
    case CameraLensDirection.external:
      return cameras[2];
  }
  throw ArgumentError('Unknown lens direction');
}

Future<AudioPlayer> playShutterSound(String fileName) async {
  AudioCache cache = new AudioCache();
  return await cache.play(fileName);
}



