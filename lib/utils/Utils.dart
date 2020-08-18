import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_matching_app/models/FaceMatchingResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';

String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

CameraDescription getCameraLensDirection(
    CameraLensDirection direction, List<CameraDescription> cameras) {
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

void showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        SizedBox(
          width: 20.0,
        ),
        Text("Comparing face..."),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<void> showFaceMatchingResultDialog(
    context, FaceMatchingResponse response) async {
  await showDialog(
    context: context,
    barrierDismissible: true, // by default is true
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: <Widget>[
            Icon(
              response != null
                  ? response.isMatch != null
                      ? response.isMatch ? Icons.check : Icons.close
                      : Icons.help_outline
                  : Icons.warning,
              size: 26,
              color: response != null
                  ? response.isMatch != null
                      ? response.isMatch ? Colors.green : Colors.red
                      : Colors.black
                  : Colors.black,
            ),
            SizedBox(width: 10.0),
            Text('Face Matching Result'),
          ],
        ),
        content: Text(
          response != null
              ? response.isMatch != null
                  ? response.isMatch
                      ? "Your face is matched"
                      : "Your face is not match"
                  : "No face found in either image or video"
              : "Face matching API timeout",
        ),
      );
    },
  );
}

String getPrettyJSONString(jsonObject) {
  var encoder = new JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}
