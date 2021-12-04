import 'package:bytebank/models/transfers.dart';
import 'package:bytebank/screens/transferencia/list_transfer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _title = 'Ultimas Transferências';
final _buttonTitle = 'Todas as transferências';

class LastTransfers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          _title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        Consumer<Transfers>(builder: (context, transfers, child) {
          final _transfersLength = transfers.transfers.length;
          int _transfersCount = 2;

          if (_transfersLength == 0) {
            return WithoutTransfers();
          }

          if (_transfersLength < 2) {
            _transfersCount = _transfersLength;
          }

          final _lastTransfers = transfers.transfers.reversed.toList();

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: _transfersCount,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return TransferItem(_lastTransfers[index]);
            },
          );
        }),
        ElevatedButton(
          child: Text(
            _buttonTitle,
          ),
          style: ElevatedButton.styleFrom(primary: Colors.green),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TransferList();
            }));
          },
        ),
      ],
    );
  }
}

class WithoutTransfers extends StatelessWidget {
  final _title = 'Sem transferências atualmente';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(40),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          _title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
