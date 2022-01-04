import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contacts/form_contact.dart';
import 'package:bytebank/screens/contacts/list_contacts.dart';
import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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

    verify(mockContactDao.findAll()).called(1);

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);
    await tester.tap(fabNewContact);
    await pumpAndSettleFix(tester);

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    final nameTextField = find.byWidgetPredicate((widget) {
      return textFieldMatcher(widget, 'Nome Completo');
    });
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Will');

    final accountNumberTextField = find.byWidgetPredicate((widget) {
      return textFieldMatcher(widget, 'Numero da Conta');
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

bool textFieldMatcher(Widget widget, String labelText) {
  if (widget is TextField) {
    return widget.decoration.labelText == labelText;
  }
  return false;
}

Future<void> pumpAndSettleFix(WidgetTester tester) async {
  for (int i = 0; i < 5; i++) {
    await tester.pump(Duration(seconds: 1));
  }
}
