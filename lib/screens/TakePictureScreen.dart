// A screen that allows users to take a picture using a given camera.
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

import '../Utils.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen(this.camera);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
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
      appBar: AppBar(title: Text('Take an identity picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Transform.scale(
              scale: _controller.value.aspectRatio / deviceRatio,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CameraPreview(_controller),
                ),
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Container(
        height: MediaQuery.of(context).size.width * 0.2,
        width: MediaQuery.of(context).size.width * 0.2,
        child: FloatingActionButton(
          child: Icon(
            Icons.camera_alt,
            size: MediaQuery.of(context).size.width * 0.1,
          ),
          // Provide an onPressed callback.
          onPressed: () async {
            // Take the Picture in a try / catch block. If anything goes wrong,
            // catch the error.
            try {
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;

              // Construct the path where the image should be saved using the
              // pattern package.
              String formattedDate = DateFormat('dd-MM-yyyy – kk:mm:ss').format(DateTime.now());
              final path = Path.join(
                // Store the picture in the storage/emulated/ directory.
                // Find the temp directory using the `path_provider` plugin.
                (await getExternalStorageDirectory()).path, '$formattedDate.png',
              );

              // Attempt to take a picture and log where it's been saved.
              await _controller.takePicture(path);
              await playShutterSound("camera-shutter.mp3");

              // If the picture was taken, display it on a new screen.
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => DisplayPictureScreen(imagePath: path),
//                ),
//              );
              startHomeScreenForResult(path);
            } catch (e) {
              final snackBar =
                  SnackBar(content: Text('Error: ${e.code}\n${e.description}'));
              Scaffold.of(context).showSnackBar(snackBar);
            }
          },
        ),
      ),
    );
  }

  void startHomeScreenForResult(String path) {
    final String argsImagePath = "IMAGE_PATH";
    Navigator.pop(context, {argsImagePath: path});
  }
}
