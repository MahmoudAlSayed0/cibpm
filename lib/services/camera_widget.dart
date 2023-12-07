import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cibpm/logic/cubit/app_cubit.dart';
import 'package:cibpm/services/image_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({
    Key? key,
  }) : super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  bool isRecodring = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras[1];

    _controller = CameraController(firstCamera, ResolutionPreset.ultraHigh,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
    await _controller.initialize();

    // await _controller.setFocusMode(FocusMode.locked);
    // await _controller.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
    await _controller.setFlashMode(FlashMode.off);
    await _controller.setFocusPoint(Offset(.75, 0.5));
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCameraInitialized) {
      return BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = AppCubit().get(context);
          return Column(
            children: [
              Expanded(
                child: CameraPreview(
                  _controller,
                  child: Stack(children: [
                    RecordButton(controller: _controller, cubit: cubit),
                    StopButton(controller: _controller, cubit: cubit),
                  ]),
                ),
              ),
              Row(
                children: [],
              )
            ],
          );
        },
      );
    } else {
      return Center(child: const CircularProgressIndicator());
    }
  }
}

class StopButton extends StatelessWidget {
  const StopButton({
    super.key,
    required CameraController controller,
    required AppCubit this.cubit,
  }) : _controller = controller;

  final CameraController _controller;
  final AppCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: IconButton.outlined(
        iconSize: 40,
        color: Colors.white,
        onPressed: () async {
          //TODO : put stuff here
          await _controller.stopImageStream();
          // XFile video = await _controller.stopVideoRecording();
          // log(video.path);
          await cubit.extractGreens();
        },
        icon: Icon(Icons.stop),
      ),
    );
  }
}

class RecordButton extends StatelessWidget {
  const RecordButton({
    super.key,
    required CameraController controller,
    required AppCubit this.cubit,
  }) : _controller = controller;

  final CameraController _controller;
  final AppCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: IconButton.outlined(
        iconSize: 40,
        color: Colors.white,
        onPressed: () async {
          //TODO : put stuff here
          // _controller.startVideoRecording();

          _controller.startImageStream((image) async {
            // int greens = await ImageProcessor.processImage(image);
            // log('${greens.toString()} ');
            cubit.storeImage(image);
          });
        },
        icon: Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}

/* class CameraHandler {
  static useCamera() async {
    var cameras = await checkForCameras();
    
  }

  static Future<List<CameraDescription>> checkForCameras() async {
    try {
      List<CameraDescription> cameras = await availableCameras();
      return cameras;
    } on CameraException catch (e) {
      log('Error in fetching the cameras: $e');
      return [];
    }
  }
  
} */
