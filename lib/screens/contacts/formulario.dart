import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _titleAppbar = 'Novo Contato';

  final _labelName = 'Nome Completo';

  final _hintName = 'Maria Bank';

  final _labelAccount = 'Numero da Conta';

  final _hintAccount = '1000';

  final _labelButton = 'Adicionar';

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _accountNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppbar),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _nameController,
                decoration:
                    InputDecoration(labelText: _labelName, hintText: _hintName),
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                    labelText: _labelAccount, hintText: _hintAccount),
                style: TextStyle(
                  fontSize: 24.0,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    final String name = _nameController.text;
                    final int accountNumber = int.tryParse(_accountNumberController.text);
                  },
                  child: Text(_labelButton),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
