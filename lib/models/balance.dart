import 'package:flutter/cupertino.dart';

class Balance extends ChangeNotifier {
  final double value;

  Balance(this.value);

  @override
  String toString() {
    return 'R\$ $value';
  }
}
