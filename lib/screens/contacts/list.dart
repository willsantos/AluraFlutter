import 'package:bytebank/screens/contacts/formulario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  final _titleAppbar = 'Contatos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titleAppbar)),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text(
                'NOME',
                style: TextStyle(fontSize: 24),
              ),
              subtitle: Text(
                '1000',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ContactForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
