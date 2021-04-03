import 'package:bytebank/models/transfers.dart';
import 'package:bytebank/screens/transferencia/formulario.dart';
import 'package:flutter/material.dart';

const _titleAppBar = 'Transferencias';

class transferList extends StatefulWidget {
  final List<transfer> _transfers = [];

  @override
  State<StatefulWidget> createState() {
    return transferListState();
  }
}

class transferListState extends State<transferList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_titleAppBar),
        ),
        body: ListView.builder(
          itemCount: widget._transfers.length,
          itemBuilder: (context, index) {
            final transfer = widget._transfers[index];
            return TransferItem(transfer);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FormularioTransferencia();
            })).then(
              (transferReceived) => _update(transferReceived),
            );
          },
        ));
  }

  void _update(transfer transferReceived) {
    if (transferReceived != null) {
      setState(() {
        widget._transfers.add(transferReceived);
      });
    }
  }
}

class TransferItem extends StatelessWidget {
  final transfer _transfer;

  TransferItem(this._transfer);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transfer.value.toString()),
        subtitle: Text(_transfer.accountNumber.toString()),
      ),
    );
  }
}
