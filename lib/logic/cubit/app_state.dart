part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

final class CapturingVideo extends AppState {}

final class VideoCaptured extends AppState {}

final class SettingVideoPath extends AppState {}

final class VideoPathSet extends AppState {}
