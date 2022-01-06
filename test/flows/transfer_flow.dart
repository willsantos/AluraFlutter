import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/contacts/list_contacts.dart';
import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:bytebank/screens/transactions/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/pumpAndSeatleFix.dart';
import '../matchers/matchers.dart';
import '../mocks/mocks.dart';
import 'events/clickEvents.dart';

void main() {
  testWidgets('Should transfer to a contact', (tester) async {
    final mockContactDao = MockContactDao();
    final mockTransactionRoutes = MockTransactionRoutes();
    await tester.pumpWidget(ByteBank(
      contactDao: mockContactDao,
      transactionRoutes: mockTransactionRoutes,
    ));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    var contactWill = Contact(0, 'Will', 1000);
    when(mockContactDao.findAll())
        .thenAnswer((realInvocation) async => [contactWill]);

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

    final contactName = find.text('Will');
    expect(contactName, findsOneWidget);

    final contactAccountNumber = find.text('1000');
    expect(contactAccountNumber, findsOneWidget);

    final textFieldValue = find.byWidgetPredicate(
        (widget) => textFieldByLabelTextMatcher(widget, 'Value'));
    expect(textFieldValue, findsOneWidget);

    await tester.enterText(textFieldValue, '200');

    final transferButton = find.widgetWithText(ElevatedButton, 'Transfer');
    expect(transferButton, findsOneWidget);

    await tester.tap(transferButton);
    await pumpAndSettleFix(tester);

    final transactionAuthDialog = find.byType(TransactionAuthDialog);
    expect(transactionAuthDialog, findsOneWidget);

    final textFieldPassword =
        find.byKey(transactionAuthDialogTextFieldPasswordKey);
    expect(textFieldPassword, findsOneWidget);

    await tester.enterText(textFieldPassword, '1000');

    final cancelButton = find.widgetWithText(TextButton, 'Cancel');
    expect(cancelButton, findsOneWidget);

    final confirmButton = find.widgetWithText(TextButton, 'Confirm');
    expect(confirmButton, findsOneWidget);

    when(mockTransactionRoutes.save(
            Transaction(null, 200, contactWill), '1000'))
        .thenAnswer((_) async => Transaction(null, 200, contactWill));

    await tester.tap(confirmButton);
    await pumpAndSettleFix(tester);

    final sucessDialog = find.byType(SuccessDialog);
    expect(sucessDialog, findsOneWidget);

    final okButton = find.widgetWithText(TextButton, 'Ok');
    expect(okButton, findsOneWidget);

    await tester.tap(okButton);
    await pumpAndSettleFix(tester);

    final contactsListReturned = find.byType(ContactsList);
    expect(contactsListReturned, findsOneWidget);
  });
}
