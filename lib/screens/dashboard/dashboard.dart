import 'package:flutter/material.dart';

const _titleAppBar = 'Dashboard';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body: Column(
        children: [
          Image.asset('images/bytebank_logo.png'),
          Container(
            color: Colors.green[700],
            width: 120,
            height: 100,
            child: Column(
              children: [
                Icon(Icons.people),
                Text('Contatos'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
