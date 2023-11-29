import 'dart:io';

import 'package:cibpm/logic/cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class Preview extends StatefulWidget {
  const Preview({Key? key, required this.videoPath}) : super(key: key);
  final String videoPath;

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  late final VideoPlayerController _controller;
  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.videoPath));
    _controller.initialize().then((value) => setState(() {
          _controller.setLooping(true);
          _controller.play();
        }));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit().get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('CIBPM'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _controller.value.isInitialized
                    ? SizedBox(
                        height: 400,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : Container(),
                TextButton(
                    child: _controller.value.isPlaying
                        ? Text('pause')
                        : Text('play'),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    }),
                TextButton(
                  onPressed: () {},
                  child: Text('Compress'),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('send '),
                ),
                IconButton(
                    onPressed: () async {
                      await cubit.pickOnPressed();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Preview(videoPath: cubit.videoPath!)));
                    },
                    icon: Icon(Icons.camera))
              ],
            ),
          ),
        );
      },
    );
  }
}
