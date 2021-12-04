import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/balance.dart';
import 'package:bytebank/models/transfer.dart';
import 'package:bytebank/models/transfers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _titleAppBar = 'Criando Transferencia';
const _labelValue = "Valor";
const _hintValue = "1.00";
const _labelAccountNumber = "Numero da Conta";
const _hintNumberAccount = "1000";
const _textButtonConfirm = 'confirmar';

class TransferForm extends StatelessWidget {
  final TextEditingController _controllerAccountNumber =
      TextEditingController();
  final TextEditingController _controllerValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Editor(
                controller: _controllerAccountNumber,
                label: _labelAccountNumber,
                hint: _hintNumberAccount),
            Editor(
                controller: _controllerValue,
                label: _labelValue,
                hint: _hintValue,
                icon: Icons.monetization_on),
            ElevatedButton(
              onPressed: () => _addTransfer(context),
              child: Text(_textButtonConfirm),
            ),
          ],
        ),
      ),
    );
  }

  void _addTransfer(BuildContext context) {
    final int accountNumber = int.tryParse(_controllerAccountNumber.text);
    final double valor = double.tryParse(_controllerValue.text);
    _validateTransfer(accountNumber, valor, context);
  }

  void _validateTransfer(
      int accountNumber, double valor, BuildContext context) {
    if (accountNumber != null && valor != null) {
      final _balanceDiff = valor <=
          Provider.of<Balance>(
            context,
            listen: false,
          ).value;
      if (_balanceDiff) {
        final newTransfer = Transfer(valor, accountNumber);
        _updateState(context, newTransfer, valor);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$newTransfer'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saldo insuficiente'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dados inválidos, transferencia não efetuada'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  _updateState(context, newTransfer, value) {
    Provider.of<Transfers>(context, listen: false).add(newTransfer);
    Provider.of<Balance>(context, listen: false).deduct(value);
  }
}
