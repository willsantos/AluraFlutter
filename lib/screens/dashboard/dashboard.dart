import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/localization.dart';
import 'package:bytebank/models/name.dart';
import 'package:bytebank/screens/contacts/list_contacts.dart';
import 'package:bytebank/screens/name/name.dart';
import 'package:bytebank/screens/transactions/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _titleAppBar = 'Dashboard';

class DashboardContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NameCubit("Wilson"),
      child: I18NLoadingContainer(
        translateScreen: 'Dashboard',
        translateLocale: ViewI18N(context).language,
        creator: (messages) => DashboardView(DashboardViewLazyI18N(messages)),
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  final DashboardViewLazyI18N _i18n;

  DashboardView(this._i18n);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NameCubit, String>(
          builder: (context, state) => Text("$_titleAppBar $state"),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank_logo.png'),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FeatureItem(
                  _i18n.transfer,
                  Icons.monetization_on,
                  onClick: () => _showContactsList(context),
                ),
                _FeatureItem(
                  _i18n.transaction_feed,
                  Icons.description,
                  onClick: () => _showTransfersList(context),
                ),
                _FeatureItem(
                  _i18n.change_name,
                  Icons.person_outline,
                  onClick: () => _showChangeName(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactsList(BuildContext context) {
    push(context, ContactsListContainer());
  }

  void _showTransfersList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransactionsList(),
      ),
    );
  }

  void _showChangeName(BuildContext blocContext) {
    Navigator.of(blocContext).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<NameCubit>(blocContext),
          child: NameContainer(),
        ),
      ),
    );
  }
}

class DashboardViewLazyI18N {
  final I18NMessages _messages;

  DashboardViewLazyI18N(this._messages);

  String get transfer => _messages.get("transfer");
  String get transaction_feed => _messages.get("transaction_feed");
  String get change_name => _messages.get("change_name");
}

class DashboardViewI18N extends ViewI18N {
  DashboardViewI18N(BuildContext context) : super(context);

  String get transfer => localize({"pt-br": "Transferir", "en": "Transfer"});

  String get transaction_feed =>
      localize({"pt-br": "Transações", "en": "Transaction Feed"});

  String get change_name =>
      localize({"pt-br": "Mudar Nome", "en": "Change Name"});
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  _FeatureItem(
    this.name,
    this.icon, {
    @required this.onClick,
  })  : assert(icon != null),
        assert(onClick != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () {
            onClick();
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: 130,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
