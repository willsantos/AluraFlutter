import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'database/dao/contact_dao.dart';
// import 'package:sqflite/sqflite.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(ByteBank(
    contactDao: ContactDao(),
  ));
}

class ByteBank extends StatelessWidget {
  final ContactDao contactDao;
  ByteBank({@required this.contactDao});

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
      home: Dashboard(contactDao: contactDao),
    );
  }
}
