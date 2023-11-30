import 'dart:developer';
import 'dart:io';

import 'package:cibpm/models/api_creds.dart';
import 'package:cibpm/models/response_model.dart';
import 'package:cibpm/models/results_model.dart';
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
  ApiResponse? response;
  bool isRequesting = false;
  bool gotResults = false;
  MessageResult? finalResults;
  int? difference;

  pickOnPressed() async {
    emit(CapturingVideo());
    await ImagePickerHelper.pickVideo(onPick: (file) async {
      await setVideoPath(file.path);
      int sizeInBytes = await file.length();

      log('file size in KB = ${sizeInBytes / 1024}');
      isCompressed = false;
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
    emit(SendingVideo());
    ApiCreds creds = await DioHelper.postVideo(videoPath!);
    response = creds.response;
    emit(VideoSent());
  }

  getResultsOnPressed() async {
    emit(FetchingResults());
    isRequesting = true;
    DateTime beforeTime = DateTime.now();

    finalResults = await DioHelper.getResults(response!);
    log(finalResults.toString());
    isRequesting = false;
    gotResults = true;
    DateTime afterTime = DateTime.now();
    difference = afterTime.difference(beforeTime).inSeconds;
    emit(ResultsFetched());
  }

  setVideoPath(String path) async {
    emit(SettingVideoPath());
    videoPath = path;

    log('Video path set at ' + videoPath!);
    emit(VideoPathSet());
  }
}
