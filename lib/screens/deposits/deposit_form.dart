import 'package:bytebank/components/progress.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/models/balance.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _titleAppBar = 'Receber Depósito';
const _hintValue = '0.00';
const _labelValue = 'valor';
const _textButtonConfirm = 'Confirmar';

class DepositForm extends StatelessWidget {
  final TextEditingController _valueController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Progress(
                    message: 'Sending...',
                  ),
                ),
                visible: false,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: _labelValue),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text(_textButtonConfirm),
                    onPressed: () {
                      _createDeposit(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _createDeposit(context) {
    final double value = double.tryParse(_valueController.text);

    if (_validateDeposit(value)) {
      _updateDeposit(context, value);
      Navigator.pop(context);
    }
  }

  _validateDeposit(value) {
    return value != null;
  }

  _updateDeposit(context, value) {
    Provider.of<Balance>(context, listen: false).add(value);
  }
}
