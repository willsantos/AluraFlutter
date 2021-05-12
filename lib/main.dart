import 'dart:async';

import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/models/balance.dart';
import 'package:bytebank/screens/dashboard/newDashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
// import 'package:sqflite/sqflite.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FirebaseCrashlytics.instance.setUserIdentifier('will123');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  runZonedGuarded<Future<void>>(() async {
    runApp(ChangeNotifierProvider(
      create: (context) => Balance(0),
      child: ByteBank(),
    ));
  }, FirebaseCrashlytics.instance.recordError);

  // Initialize Firebase.

  await DotEnv.load(fileName: '.env');
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
      home: NewDashboard(),
    );
  }
}
