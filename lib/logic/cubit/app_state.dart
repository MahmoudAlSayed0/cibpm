part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

final class CapturingVideo extends AppState {}

final class VideoCaptured extends AppState {}

final class SettingVideoPath extends AppState {}

final class VideoPathSet extends AppState {}

final class CompressingVideo extends AppState {}

final class VideoCompressed extends AppState {}

final class SendingVideo extends AppState {}

final class VideoSent extends AppState {}

final class FetchingResults extends AppState {}

final class ResultsFetched extends AppState {}

class ImageStored extends AppState {}

class StoringImage extends AppState {}

class ExtractingGreens extends AppState {}

class GreensExtracted extends AppState {}
