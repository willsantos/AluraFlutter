import 'package:flutter_test/flutter_test.dart';

Future<void> pumpAndSettleFix(WidgetTester tester) async {
  for (int i = 0; i < 5; i++) {
    await tester.pump(Duration(seconds: 1));
  }
}
