import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contacts/form_contact.dart';
import 'package:bytebank/screens/transactions/transaction_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class ContactsListState {
  const ContactsListState();
}

@immutable
class InitContactsListState extends ContactsListState {
  const InitContactsListState();
}

@immutable
class LoadingContactsListState extends ContactsListState {
  const LoadingContactsListState();
}

@immutable
class LoadedContactsListState extends ContactsListState {
  final List<Contact> _contacts;
  const LoadedContactsListState(this._contacts);
}

@immutable
class FatalErrorContactsListState extends ContactsListState {
  const FatalErrorContactsListState();
}

class ContactListCubit extends Cubit<ContactsListState> {
  ContactListCubit() : super(InitContactsListState());

  void reload(ContactDao dao) async {
    emit(LoadingContactsListState());
    dao.findAll().then((contacts) => emit(LoadedContactsListState(contacts)));
  }
}

class ContactsListContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    final ContactDao dao = ContactDao();
    return BlocProvider<ContactListCubit>(
      child: ContactsList(dao),
      create: (BuildContext context) {
        final cubit = ContactListCubit();
        cubit.reload(dao);
        return cubit;
      },
    );
  }
}

class ContactsList extends StatelessWidget {
  final _titleAppbar = 'Transfer';

  final ContactDao _dao;

  ContactsList(this._dao);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titleAppbar)),
      body: BlocBuilder<ContactListCubit, ContactsListState>(
          builder: (context, state) {
        if (state is InitContactsListState ||
            state is LoadingContactsListState) {
          return Progress();
        }
        if (state is LoadedContactsListState) {
          final List<Contact> contacts = state._contacts;
          return ListView.builder(
            itemBuilder: (context, index) {
              final Contact contact = contacts[index];
              return _ContactItem(contact, onClick: () {
                push(context, TransactionFormContainer(contact));
              });
            },
            itemCount: contacts.length,
          );
        }
        return const Text('Unknown error');
      }),
      floatingActionButton: buildAddContactButton(context),
    );
  }

  FloatingActionButton buildAddContactButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ContactForm()),
        );
        context.bloc<ContactListCubit>().reload(_dao);
      },
      child: Icon(Icons.add),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  _ContactItem(
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
