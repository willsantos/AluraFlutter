import 'package:bytebank/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers/matchers.dart';

void main() {
  group('When Dashboard is opened', () {
    testWidgets('Should display the main image', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Dashboard()));
      final mainImage = find.byType(Image);
      expect(mainImage, findsOneWidget);
    });

    testWidgets('Should display the first feature',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Dashboard()));
      final firstFeature = find.byType(FeatureItem);
      expect(firstFeature, findsWidgets);
    });

    testWidgets('Should display the transfer feature item',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Dashboard()));

      final transferFeatureItem = find.byWidgetPredicate((widget) =>
          featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
      expect(transferFeatureItem, findsOneWidget);
    });

    testWidgets('Should display the transaction feed feature item',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Dashboard()));

      final transactionFeedFeatureItem = find.byWidgetPredicate((widget) =>
          featureItemMatcher(widget, 'Transaction Feed', Icons.description));
      expect(transactionFeedFeatureItem, findsOneWidget);
    });
  });
}
