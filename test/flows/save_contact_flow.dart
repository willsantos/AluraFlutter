import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contacts/form_contact.dart';
import 'package:bytebank/screens/contacts/list_contacts.dart';
import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/pumpAndSeatleFix.dart';
import '../matchers/matchers.dart';
import '../mocks/mocks.dart';
import 'events/clickEvents.dart';

void main() {
  testWidgets('Should save a contact', (tester) async {
    final mockContactDao = MockContactDao();
    await tester.pumpWidget(ByteBank(contactDao: mockContactDao));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    await clickOnTheTransferFeatureItem(tester);
    await pumpAndSettleFix(tester);

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll()).called(1);

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);
    await pumpAndSettleFix(tester);

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    final nameTextField = find.byWidgetPredicate((widget) {
      return textFieldByLabelTextMatcher(widget, 'Nome Completo');
    });
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Will');

    final accountNumberTextField = find.byWidgetPredicate((widget) {
      return textFieldByLabelTextMatcher(widget, 'Numero da Conta');
    });
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, '1000');

    final createButton = find.widgetWithText(ElevatedButton, 'Adicionar');
    expect(createButton, findsOneWidget);
    await tester.tap(createButton);
    await pumpAndSettleFix(tester);
    verify(mockContactDao.save(Contact(0, 'Will', 1000)));

    final contactsListReturned = find.byType(ContactsList);
    expect(contactsListReturned, findsOneWidget);
    verify(mockContactDao.findAll());
  });
}
