import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/services/routes/transactions_routes.dart';
import 'package:flutter/material.dart';

class AppDependencies extends InheritedWidget {
  final ContactDao contactDao;
  final TransactionRoutes transactionRoute;
  AppDependencies({
    @required this.contactDao,
    @required this.transactionRoute,
    @required Widget child,
  }) : super(child: child);

  static AppDependencies of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDependencies>();

  @override
  bool updateShouldNotify(covariant AppDependencies oldWidget) {
    return contactDao != oldWidget.contactDao ||
        transactionRoute != oldWidget.transactionRoute;
  }
}
