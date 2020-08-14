import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../Utils.dart';
import 'DisplayPictureScreen.dart';

class TakeVideoScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakeVideoScreen(this.camera);

  @override
  _TakeVideoScreenState createState() => _TakeVideoScreenState();
}

class _TakeVideoScreenState extends State<TakeVideoScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String videoPath;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(title: Text('Take a selfie video')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Transform.scale(
              scale: _controller.value.aspectRatio / deviceRatio,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CameraPreview(_controller),
                ),
              ),
            );
          else
            return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: Container(
        height: MediaQuery.of(context).size.width * 0.2,
        width: MediaQuery.of(context).size.width * 0.2,
        child: FloatingActionButton(
            child: Icon(
              !_controller.value.isRecordingVideo ? Icons.videocam : Icons.stop,
              size: MediaQuery.of(context).size.width * 0.1,
              color: !_controller.value.isRecordingVideo ? null : Colors.red,
            ),
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                await playShutterSound("start-stop-record.mp3");
                if (_controller != null &&
                    _controller.value.isInitialized &&
                    !_controller.value.isRecordingVideo)
                  onVideoRecordButtonPressed();
                else
                  onStopButtonPressed();
              } catch (e) {
                showInSnackBar('Error: ${e.code}\n${e.description}');
              }
            }),
      ),
    );
  }

  /// [Start] video recording functions
  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
    });
  }

  /// [Stop] video recording functions
  void onStopButtonPressed() {
    stopVideoRecording().then((_) async {
      if (mounted) setState(() {});
    });
  }

  Future<String> startVideoRecording() async {
    if (!_controller.value.isInitialized) return null;

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Face Matching/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (_controller.value.isRecordingVideo) return null;

    try {
      videoPath = filePath;
      await _controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      showInSnackBar('Error: ${e.code}\n${e.description}');
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) return null;

    try {
      await _controller.stopVideoRecording();
      startHomeScreenForResult(videoPath);
    } on CameraException catch (e) {
      showInSnackBar('Error: ${e.code}\n${e.description}');
      return null;
    }
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void startHomeScreenForResult(String path) {
    final String argsVideoPath = "VIDEO_PATH";
    Navigator.pop(context, {argsVideoPath: path});
  }
}
