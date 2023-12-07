import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ImageProcessor {
  static Future<int> processImage(CameraImage image) async {
    DateTime beforeTime = DateTime.now();
    log(DateTime.now().toString());
    if (image.format.group != ImageFormatGroup.yuv420) {
      // Ensure the image format is suitable for your processing (e.g., YUV420)
      log('FormatGroup is not supported');
      return 0;
    }
    int greens = await extractGreens(image);
    log(DateTime.now().difference(beforeTime).inMilliseconds.toString());
    return greens;
  }

  static Future<int> extractGreens(CameraImage cameraImage) async {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    int greenSum = 0;

    for (int h = 0; h < imageHeight; h++) {
      int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        int uvw = (w / 2).floor();

        final yIndex = (h * yRowStride) + (w * yPixelStride);

        // Y plane should have positive values belonging to [0...255]
        final int y = yBuffer[yIndex];

        // U/V Values are subsampled i.e. each pixel in U/V chanel in a
        // YUV_420 image act as chroma value for 4 neighbouring pixels
        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
        // [0, 255] range they are scaled up and centered to 128.
        // Operation below brings U/V values to [-128, 127].
        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        // Compute RGB values per formula above.
        //  int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        //  int b = (y + u * 1814 / 1024 - 227).round();

        //  r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        //  b = b.clamp(0, 255);

        // Add the green value to the sum
        greenSum += g;
      }
    }

    return greenSum;
  }
}

class YuvChannelling {
  MethodChannel platform =
      const MethodChannel('tomer.blecher.yuv_transform/yuv');

  ///  Transform given image to JPEG compressed through native code.
  ///
  ///  Function gets [CameraImage] in YUV format for processing and returns
  ///  [Uint8List] of JPEG bytes.
  ///
  Future<Uint8List> yuv_transform(CameraImage image) async {
    List<int> strides = new Int32List(image.planes.length * 2);
    int index = 0;
    // We need to transform the image to Uint8List so that the native code could
    // transform it to byte[]
    List<Uint8List> data = image.planes.map((plane) {
      strides[index] = (plane.bytesPerRow);
      index++;
      strides[index] = (plane.bytesPerPixel)!;
      index++;
      return plane.bytes;
    }).toList();
    Uint8List image_jpeg = await platform.invokeMethod('yuv_transform', {
      'platforms': data,
      'height': image.height,
      'width': image.width,
      'strides': strides
    });

    return image_jpeg;
  }
}
