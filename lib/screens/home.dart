import 'package:cibpm/logic/cubit/app_cubit.dart';
import 'package:cibpm/screens/preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              children: [
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
