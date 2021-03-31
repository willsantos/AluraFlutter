import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:flutter/material.dart';

const _titleAppBar = 'Criando Transferencia';
const _labelValor = "Valor";
const _hintValor = "1.00";
const _labelNumeroConta = "Numero da Conta";
const _hintNumeroConta = "1000";
const _textButtonConfirmar = 'confirmar';

class FormularioTransferencia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controllerNumeroConta = TextEditingController();
  final TextEditingController _controllerValor = TextEditingController();

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
                controller: _controllerNumeroConta,
                label: _labelNumeroConta,
                hint: _hintNumeroConta),
            Editor(
                controller: _controllerValor,
                label: _labelValor,
                hint: _hintValor,
                icon: Icons.monetization_on),
            ElevatedButton(
              onPressed: () => _criaTransferencia(context),
              child: Text(_textButtonConfirmar),
            ),
          ],
        ),
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
    final int numeroConta = int.tryParse(_controllerNumeroConta.text);
    final double valor = double.tryParse(_controllerValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$transferenciaCriada'),
        ),
      );
      Navigator.pop(context, transferenciaCriada);
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