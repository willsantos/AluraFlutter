import 'package:bytebank/components/balance_card.dart';
import 'package:bytebank/models/balance.dart';
import 'package:flutter/material.dart';

class NewDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bytebank'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: BalanceCard(),
      ),
    );
  }
}
