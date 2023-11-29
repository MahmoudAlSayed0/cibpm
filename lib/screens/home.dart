import 'package:cibpm/logic/cubit/app_cubit.dart';
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
                    onPressed: cubit.pickOnPressed, icon: Icon(Icons.camera))
              ],
            ),
          ),
        );
      },
    );
  }
}
