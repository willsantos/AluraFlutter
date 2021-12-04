import 'package:bytebank/components/balance_card.dart';
import 'package:bytebank/models/balance.dart';
import 'package:bytebank/screens/deposits/deposit_form.dart';
import 'package:bytebank/screens/transferencia/components/last_transfers.dart';
import 'package:bytebank/screens/transferencia/form_transfer.dart';
import 'package:bytebank/screens/transferencia/list_transfer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bytebank'),
        ),
        body: ListView(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: BalanceCard(),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Receber depósito'),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DepositForm();
                    }));
                  },
                ),
                ElevatedButton(
                  child: Text('Nova Transferencia'),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TransferForm();
                    }));
                  },
                ),
              ],
            ),
            LastTransfers(),
          ],
        ));
  }
}
