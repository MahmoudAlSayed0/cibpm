import 'dart:developer';
import 'dart:io';

import 'package:cibpm/services/compressor.dart';
import 'package:cibpm/services/dio_helper.dart';
import 'package:cibpm/services/image_picker.dart';
import 'package:cibpm/services/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_compress/video_compress.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  AppCubit get(context) => BlocProvider.of(context);
  String? videoPath;
  bool isCompressed = false;

  pickOnPressed() async {
    emit(CapturingVideo());
    await ImagePickerHelper.pickVideo(onPick: (file) async {
      await setVideoPath(file.path);
      int sizeInBytes = await file.length();

      log('file size in KB = ${sizeInBytes / 1024}');
    });
    emit(VideoCaptured());
  }

  compressOnPressed(BuildContext context) async {
    emit(CompressingVideo());
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Dialog(
              child: ProgressDialogWidget(),
            ));
    MediaInfo? compressedVideo =
        await VideoCompressApi.compressVideo(File(videoPath!));
    log('video compressed and size is ${compressedVideo!.filesize! / 1024}');
    setVideoPath(compressedVideo!.path!);
    isCompressed = true;
    Navigator.of(context).pop();
    emit(VideoCompressed());
  }

  sendOnPressed() async {
    await DioHelper.postVideo(videoPath!);
  }

  setVideoPath(String path) async {
    emit(SettingVideoPath());
    videoPath = path;

    log('Video path set at ' + videoPath!);
    emit(VideoPathSet());
  }
}
