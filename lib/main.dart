import 'package:cibpm/logic/cubit/app_cubit.dart';
import 'package:cibpm/screens/greens.dart';
import 'package:cibpm/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: MaterialApp(home: GreenExtractorScreen()),
    );
  }
}
