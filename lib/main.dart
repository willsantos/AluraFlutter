import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'components/localization.dart';
// import 'package:sqflite/sqflite.dart';

Future main() async {
  await dotenv.load(fileName: '.env');

  runApp(ByteBank());
}

class LogObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print("${cubit.runtimeType} => $change");
    super.onChange(cubit, change);
  }
}

class ByteBank extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bloc.observer = LogObserver();
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[900],
        secondaryHeaderColor: Colors.blueAccent[700],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: LocalizationContainer(
        child: DashboardContainer(),
      ),
    );
  }
}
