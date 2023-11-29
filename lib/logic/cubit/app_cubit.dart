import 'dart:developer';

import 'package:cibpm/services/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  AppCubit get(context) => BlocProvider.of(context);
  String? videoPath;

  void pickOnPressed() async {
    emit(CapturingVideo());
    await ImagePickerHelper.pickVideo(onPick: (file) async {
      await setVideoPath(file.path);
      int sizeInBytes = await file.length();

      log('file size in KB = ${sizeInBytes / 1024}');
    });
    emit(VideoCaptured());
  }

  setVideoPath(String path) async {
    emit(SettingVideoPath());
    videoPath = path;

    log('Video path set at ' + videoPath!);
    emit(VideoPathSet());
  }
}
