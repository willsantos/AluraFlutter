import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/transfers.dart';
import 'package:flutter/material.dart';

const _titleAppBar = 'Criando Transferencia';
const _labelValue = "Valor";
const _hintValue = "1.00";
const _labelAccountNumber = "Numero da Conta";
const _hintNumberAccount = "1000";
const _textButtonConfirm = 'confirmar';

class TransferForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TransferFormState();
  }
}

class TransferFormState extends State<TransferForm> {
  final TextEditingController _controllerAccountNumber = TextEditingController();
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
    if (accountNumber != null && valor != null) {
      final transferCreated = Transfer(valor, accountNumber);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$transferCreated'),
        ),
      );
      Navigator.pop(context, transferCreated);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dados inválidos, transferencia não efetuada'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}