import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_matching_app/models/FaceMatchingResponse.dart';
import 'package:flutter_face_matching_app/network/FaceMatching.dart';
import 'package:flutter_face_matching_app/screens/widgets/ImageVideoRowPreviewWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'file:///D:/Flutter-Projects/flutter_face_matching_app/lib/screens/TakePictureScreen.dart';
import 'file:///D:/Flutter-Projects/flutter_face_matching_app/lib/screens/TakeVideoScreen.dart';
import '../Utils.dart';

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
      body: Column(
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
                    dynamic result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TakePictureScreen(
                            getCameraLensDirection(
                                CameraLensDirection.back, cameras)),
                      ),
                    );

                    if (result != null) {
                      // if data[argsImagePath is null, we add it
                      // else, we replace it
                      data[argsImagePath] == null
                          ? data.addAll(result)
                          : data[argsImagePath] = result[argsImagePath];
//                      ImageGallerySaver.saveImage(
////                          Uint8List.fromList(response.data), ,
//                          result[argsImagePath]);
                    }

                    setState(() {});
                  },
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  child: Text(
                    'Take a selfie video',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    dynamic result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TakeVideoScreen(
                          getCameraLensDirection(
                              CameraLensDirection.front, cameras),
                        ),
                      ),
                    );

                    if (result != null) {
                      // if data[argsVideoPath is null, we add it
                      // else, we replace it
                      data[argsVideoPath] == null
                          ? data.addAll(result)
                          : data[argsVideoPath] = result[argsVideoPath];
                      await _startVideoPlayer(result[argsVideoPath]);
                    }

                    setState(() {});
                  },
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                    child: Text('Submit for face matching',
                        style: TextStyle(fontSize: 16)),
                    onPressed: () async {
//                    CircularProgressIndicator()
                      // TODO show a blur background and spinkit
                      // TODO show a dialog when gotten result
                      if (data[argsImagePath] != null &&
                          data[argsVideoPath] != null) {
                        FaceMatchingAPI faceMatching = FaceMatchingAPI(
                            data[argsImagePath], data[argsVideoPath]);
                        FaceMatchingResponse response =
                            await faceMatching.compareFace();
                        this.response = response;

                        setState(() {});
                      } else {
                        showToast(flutterToast);
                      }
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
    );
  }

  String getFaceMatchingApiResponse() {
    if (response == null)
      return "JSON result will show here";
    else
      return getPrettyJSONString(response.toJson());
  }

  String getPrettyJSONString(jsonObject){
    var encoder = new JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }
}
