import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:bytebank/services/routes/transactions_routes.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'database/dao/contact_dao.dart';
// import 'package:sqflite/sqflite.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(ByteBank(
    contactDao: ContactDao(),
    transactionRoutes: TransactionRoutes(),
  ));
}

class ByteBank extends StatelessWidget {
  final ContactDao contactDao;
  final TransactionRoutes transactionRoutes;
  ByteBank({
    @required this.contactDao,
    @required this.transactionRoutes,
  });

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      contactDao: contactDao,
      transactionRoute: transactionRoutes,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green[900],
          accentColor: Colors.blueAccent[700],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent[700],
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        home: Dashboard(),
      ),
    );
  }
}
