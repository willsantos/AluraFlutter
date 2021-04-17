import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';

Future main() async {
  await DotEnv.load();
  runApp(ByteBank());

}

class ByteBank extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[900],
        accentColor: Colors.blueAccent[700],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Dashboard(),
    );
  }
}
