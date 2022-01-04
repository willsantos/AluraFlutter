import 'package:bytebank/components/progress.dart';
import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contacts/form_contact.dart';
import 'package:bytebank/screens/transactions/transaction_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  final ContactDao contactDao;
  ContactsList({@required this.contactDao});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final _titleAppbar = 'Transfer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titleAppbar)),
      body: FutureBuilder<List<Contact>>(
          initialData: [],
          future: widget.contactDao.findAll(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return Progress();
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                final List<Contact> contacts = snapshot.data;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Contact contact = contacts[index];
                    return ContactItem(contact, onClick: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TransactionForm(contact),
                        ),
                      );
                    });
                  },
                  itemCount: contacts.length,
                );
                break;
            }
            return Text('Unknown error');
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                    builder: (context) => ContactForm(
                          contactDao: widget.contactDao,
                        )),
              )
              .then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  ContactItem(
    this.contact, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24),
        ),
        subtitle: Text(
          contact.account.toString(),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
