import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

void showToast(flutterToast, msg) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.yellowAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline),
        SizedBox(
          width: 12.0,
        ),
        Expanded(child: Text(msg)),
      ],
    ),
  );

  flutterToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 3),
  );
}



