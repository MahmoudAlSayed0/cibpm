import 'package:cibpm/logic/cubit/app_cubit.dart';
import 'package:cibpm/services/results_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
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
                  cubit.isRequesting
                      ? CircularProgressIndicator()
                      : TextButton(
                          onPressed: cubit.getResultsOnPressed,
                          child: Text('Get Results')),
                  cubit.gotResults
                      ? ResultsWidget(
                          results: cubit.finalResults!,
                          elapsedTime: cubit.difference.toString(),
                        )
                      : Container()
                ],
              ),
            ),
          );
        });
  }
}
