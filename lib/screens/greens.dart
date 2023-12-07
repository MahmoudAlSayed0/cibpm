import 'package:cibpm/logic/cubit/app_cubit.dart';
import 'package:cibpm/services/camera_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GreenExtractorScreen extends StatefulWidget {
  const GreenExtractorScreen({Key? key}) : super(key: key);

  @override
  _GreenExtractorScreenState createState() => _GreenExtractorScreenState();
}

class _GreenExtractorScreenState extends State<GreenExtractorScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppState>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit().get(context);

            return Scaffold(
                appBar: AppBar(
                  title: const Text('Google Vision'),
                ),
                body: CameraWidget());
          }),
    );
  }
}
