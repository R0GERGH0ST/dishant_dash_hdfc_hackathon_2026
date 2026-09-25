import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dishant_dash_hdfc_hackathon_2026/main.dart';

void main() {
  testWidgets('Navigation test: Home -> Details -> Settings -> Home', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Home Screen'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Go to Details'));
    await tester.pumpAndSettle();

    expect(find.text('Details Screen'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Go to Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings Screen'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Back to Home'));
    await tester.pumpAndSettle();

    expect(find.text('Home Screen'), findsOneWidget);
  });
}
