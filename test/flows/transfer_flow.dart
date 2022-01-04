import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contacts/list_contacts.dart';
import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:bytebank/screens/transactions/transaction_form.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/pumpAndSeatleFix.dart';
import '../mocks/mocks.dart';
import 'events/clickEvents.dart';

void main() {
  testWidgets('Should transfer to a contact', (tester) async {
    final mockContactDao = MockContactDao();
    await tester.pumpWidget(ByteBank(contactDao: mockContactDao));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    when(mockContactDao.findAll()).thenAnswer((realInvocation) async {
      return [Contact(0, 'Will', 1000)];
    });

    await clickOnTheTransferFeatureItem(tester);
    await pumpAndSettleFix(tester);

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll()).called(1);

    final contactItem = find.byWidgetPredicate((widget) {
      if (widget is ContactItem) {
        return widget.contact.name == 'Will' && widget.contact.account == 1000;
      }
      return false;
    });
    expect(contactItem, findsOneWidget);

    await tester.tap(contactItem);
    await pumpAndSettleFix(tester);

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);
  });
}
