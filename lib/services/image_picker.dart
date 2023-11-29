import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker picker = ImagePicker();

  static Future pickImage({
    ImageSource source = ImageSource.gallery,
    ValueChanged<File>? onPick,
  }) async {
    try {
      final image = await picker.pickImage(
        source: source,
      );
      if (onPick != null && image != null) {
        onPick(File(image.path));
      }
    } catch (e) {
      log('error picking image $e');
    }
  }

  static Future pickVideo({
    ImageSource source = ImageSource.camera,
    ValueChanged<File>? onPick,
  }) async {
    final video = await picker.pickVideo(
        source: source,
        maxDuration: Duration(seconds: 10),
        preferredCameraDevice: CameraDevice.front);
    try {
      if (onPick != null && video != null) {
        onPick(File(video.path));
      }
    } catch (e) {
      log('error picking image $e');
    }
  }

  static Future pickMultiImage({
    ValueChanged<List<File>>? onPick,
  }) async {
    final images = await picker.pickMultiImage();
    List<File> result = [];
    for (var image in images) {
      result.add(File(image.path));
    }
    if (onPick != null) {
      onPick(result);
    }
  }
}
