import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_matching_app/models/FaceMatchingResponse.dart';
import 'package:flutter_face_matching_app/network/FaceMatching.dart';
import 'package:flutter_face_matching_app/screens/widgets/ImageVideoRowPreviewWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import './utils/Utils.dart';

List<CameraDescription> cameras = [];
final String argsImagePath = "IMAGE_PATH";
final String argsVideoPath = "VIDEO_PATH";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  cameras = await availableCameras();

  runApp(MaterialApp(
    title: 'Face Matching',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: FaceMatchingApp('Face Matching'),
  ));
}

class FaceMatchingApp extends StatefulWidget {
  final String title;

  FaceMatchingApp(this.title);

  @override
  _FaceMatchingAppState createState() => _FaceMatchingAppState();
}

class _FaceMatchingAppState extends State<FaceMatchingApp> {
  Map data = {};
  FaceMatchingResponse response;
  VideoPlayerController videoController;
  FToast flutterToast;
  final ImagePicker _picker = ImagePicker();

  Future<void> _startVideoPlayer(String videoPath) async {
    final VideoPlayerController videoPlayerController =
        VideoPlayerController.file(File(videoPath));
    await videoPlayerController.initialize();
    if (mounted) {
      setState(() {
        videoController = videoPlayerController;
      });
    }
    await videoPlayerController.play();
  }

  @override
  void initState() {
    super.initState();
    flutterToast = FToast(context);
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            ImageVideoRowPreviewWidget(data, videoController),
            SizedBox(height: 20.0),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      'Take an identity picture',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      // https://github.com/flutter/flutter/issues/55644
                      try {
                        final pickedFile = await _picker.getImage(
                          preferredCameraDevice: CameraDevice.front,
                          source: ImageSource.camera,
                        );

                        if (pickedFile != null)
                          data[argsImagePath] = pickedFile.path;
                        else
                          data[argsImagePath] = data[argsImagePath];
                      } catch (e) {
                        showToast(flutterToast, e.runtimeType.toString());
                      }
                      setState(() {});

                      /// Use Camera plugin to take photo
//                    dynamic result = await Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => TakePictureScreen(
//                            getCameraLensDirection(
//                                CameraLensDirection.back, cameras)),
//                      ),
//                    );
                    },
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                    child: Text(
                      'Take a selfie video',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      // https://github.com/flutter/flutter/issues/55644
                      try {
                        final pickedFile = await _picker.getVideo(
                            source: ImageSource.camera,
                            preferredCameraDevice: CameraDevice.front,
                            maxDuration: const Duration(seconds: 5));

                        if (pickedFile != null) {
                          data[argsVideoPath] = pickedFile.path;
                          await _startVideoPlayer(pickedFile.path);
                        } else
                          data[argsVideoPath] = data[argsVideoPath];
                      } catch (e) {
                        showToast(flutterToast, e.runtimeType.toString());
                      }
                      setState(() {});

                      /// Use Camera plugin to record video
//                    dynamic result = await Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => TakeVideoScreen(
//                          getCameraLensDirection(
//                              CameraLensDirection.front, cameras),
//                        ),
//                      ),
//                    );
                    },
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                      child: Text('Submit for face matching',
                          style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        if (data[argsImagePath] != null &&
                            data[argsVideoPath] != null) {
                          showLoaderDialog(context);
                          await callFaceMatchingApi()
                              .then((value) => Navigator.pop(context));
                          await showFaceMatchingResultDialog(context, response);
                          setState(() {});
                        } else
                          showToast(flutterToast,
                              "Please ensure you taken photo and selfie video");
                      }),
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              child: Text(getFaceMatchingApiResponse()),
            )
          ],
        ),
      ),
    );
  }

  String getFaceMatchingApiResponse() {
    if (response == null)
      return "JSON result will show here";
    else
      return getPrettyJSONString(response.toJson());
  }

  Future<void> callFaceMatchingApi() async {
    FaceMatchingAPI faceMatching =
        FaceMatchingAPI(data[argsImagePath], data[argsVideoPath]);
    FaceMatchingResponse response = await faceMatching.compareFace();
    this.response = response;
  }
}
