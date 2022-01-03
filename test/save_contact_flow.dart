import 'package:bytebank/main.dart';
import 'package:bytebank/screens/contacts/form_contact.dart';
import 'package:bytebank/screens/contacts/list_contacts.dart';
import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers/matchers.dart';
import 'mocks/mocks.dart';

void main() {
  testWidgets('Should save a contact', (tester) async {
    final mockContactDao = MockContactDao();
    await tester.pumpWidget(ByteBank(contactDao: mockContactDao));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final transferFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
    expect(transferFeatureItem, findsOneWidget);
    await tester.tap(transferFeatureItem);
    await pumpAndSettleFix(tester);

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);
    await pumpAndSettleFix(tester);

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    final nameTextField = find.byWidgetPredicate((widget) {
      if (widget is TextField) {
        return widget.decoration.labelText == 'Nome Completo';
      }
      return false;
    });
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Will');

    final accountNumberTextField = find.byWidgetPredicate((widget) {
      if (widget is TextField) {
        return widget.decoration.labelText == 'Numero da Conta';
      }
      return false;
    });
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, '1000');

    final createButton = find.widgetWithText(ElevatedButton, 'Adicionar');
    expect(createButton, findsOneWidget);
    await tester.tap(createButton);
    await pumpAndSettleFix(tester);

    final contactsListReturned = find.byType(ContactsList);
    expect(contactsListReturned, findsOneWidget);
  });
}

Future<void> pumpAndSettleFix(WidgetTester tester) async {
  for (int i = 0; i < 5; i++) {
    await tester.pump(Duration(seconds: 1));
  }
}
