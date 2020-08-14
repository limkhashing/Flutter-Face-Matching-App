// To debug http://192.168.0.161:8080
import 'package:flutter/foundation.dart';

const FACE_MATCHING_URL = kReleaseMode
    ? "https://cardzone-face-matching.herokuapp.com/api/upload"
    : "https://matching-face.herokuapp.com/api/upload";
