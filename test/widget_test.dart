import 'package:flutter_test/flutter_test.dart';
import 'package:dishant_dash_hdfc_hackathon_2026/main.dart';

void main() {
  testWidgets('App renders WelcomeScreen with Family Asset Tracker title', (WidgetTester tester) async {
    await tester.pumpWidget(const FamilyAssetTrackerApp());
    expect(find.text('Family Asset Tracker'), findsOneWidget);
    expect(find.text('Track. Manage. Grow Together.'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
