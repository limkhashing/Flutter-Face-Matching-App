
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../HomeScreen.dart';

class ImageVideoRowPreviewWidget extends StatelessWidget {
  final Map data;
  final VideoPlayerController videoController;

  ImageVideoRowPreviewWidget(this.data, this.videoController);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: imagePreviewWidget(),
          color: Colors.black,
          height: 200.0,
          width: 150.0,
        ),
        Container(
          child: videoPreviewWidget(),
          color: Colors.black,
          height: 200.0,
          width: 150.0,
        ),
      ],
    );
  }

  Widget imagePreviewWidget() {
    if (data[argsImagePath] == null) {
      return const Center(
        child: Text('Image will show here',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center),
      );
    } else {
      return Image.file(
        File(data[argsImagePath]),
        fit: BoxFit.fitWidth,
      );
    }
  }

  Widget videoPreviewWidget() {
    if (data[argsVideoPath] == null) {
      return const Center(
        child: Text('Video will show here',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center),
      );
    } else {
      return AspectRatio(
        aspectRatio: videoController.value.aspectRatio,
        // Use the VideoPlayer widget to display the video.
        child: VideoPlayer(videoController),
      );
    }
  }
}
