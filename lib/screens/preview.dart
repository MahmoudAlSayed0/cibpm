import 'dart:io';

import 'package:cibpm/logic/cubit/app_cubit.dart';
import 'package:cibpm/screens/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class Preview extends StatefulWidget {
  const Preview({Key? key, required this.videoPath, required this.isCompressed})
      : super(key: key);
  final String videoPath;
  final bool isCompressed;

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
          _controller.setVolume(0);
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
                !cubit.isCompressed
                    ? TextButton(
                        onPressed: () async {
                          await cubit.compressOnPressed(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Preview(
                                        videoPath: cubit.videoPath!,
                                        isCompressed: cubit.isCompressed,
                                      )));
                        },
                        child: Text('Compress'),
                      )
                    : Container(),
                TextButton(
                  onPressed: () async {
                    await cubit.sendOnPressed();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Result()));
                  },
                  child: Text('send '),
                ),
                IconButton(
                    onPressed: () async {
                      await cubit.pickOnPressed();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Preview(
                                    videoPath: cubit.videoPath!,
                                    isCompressed: cubit.isCompressed,
                                  )));
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
