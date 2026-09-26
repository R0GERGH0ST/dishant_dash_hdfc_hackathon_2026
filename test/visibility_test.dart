import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dishant_dash_hdfc_hackathon_2026/main.dart';
import 'package:dishant_dash_hdfc_hackathon_2026/models/app_state.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Profile visibility toggling dynamically recalculates family assets and charts in real-time', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const FamilyAssetTrackerApp());

    // 1. Direct login as Krish (Father)
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    final state = AppState();
    final initialFamilyWealth = state.totalFamilyAssets;
    expect(initialFamilyWealth, greaterThan(0));

    // Verify all 4 mock members exist
    final profileNames = state.allFamilyProfiles.map((p) => p['name']).toList();
    expect(profileNames, contains('Krish (Father)'));
    expect(profileNames, contains('Trish (Mother)'));
    expect(profileNames, contains('Akshay (Child 1)'));
    expect(profileNames, contains('Abhishek (Child 2)'));

    // 2. Go to Settings -> Share My Profile
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share My Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share My Profile'));
    await tester.pumpAndSettle();

    // Find the visibility switches
    final switches = find.byType(Switch);
    expect(switches, findsWidgets);

    // Toggle off sharing with first listed member (Trish)
    final firstSwitch = switches.first;
    await tester.tap(firstSwitch);
    await tester.pumpAndSettle();

    // Krish is logged in: Krish CAN STILL SEE Trish's holdings!
    expect(state.totalFamilyAssets, equals(initialFamilyWealth));
    expect(state.canUserSeeMemberHoldings('Trish (Mother)', viewer: 'Krish (Father)'), isTrue);

    // But Trish CANNOT see Krish's holdings because Krish turned off sharing with Trish!
    expect(state.canUserSeeMemberHoldings('Krish (Father)', viewer: 'Trish (Mother)'), isFalse);

    // Switch active user to Trish (Mother)
    state.switchUser('Trish (Mother)', '9876543211');
    await tester.pumpAndSettle();

    // Now Trish's visible family assets EXCLUDE Krish's holdings!
    expect(state.totalFamilyAssets, lessThan(initialFamilyWealth));

    // When Trish also turns off sharing with Krish:
    state.setProfileSharing(owner: 'Trish (Mother)', target: 'Krish (Father)', isShared: false);
    await tester.pumpAndSettle();

    // Now Trish cannot see Krish AND Krish cannot see Trish:
    expect(state.canUserSeeMemberHoldings('Trish (Mother)', viewer: 'Krish (Father)'), isFalse);
    expect(state.canUserSeeMemberHoldings('Krish (Father)', viewer: 'Trish (Mother)'), isFalse);

    // Switch back to Krish (Father)
    state.switchUser('Krish (Father)', '9876543210');
    await tester.pumpAndSettle();

    // Now Krish's visible family assets are also reduced because Trish is hidden from Krish!
    expect(state.totalFamilyAssets, lessThan(initialFamilyWealth));

    // Restore sharing both ways
    state.setProfileSharing(owner: 'Krish (Father)', target: 'Trish (Mother)', isShared: true);
    state.setProfileSharing(owner: 'Trish (Mother)', target: 'Krish (Father)', isShared: true);
    await tester.pumpAndSettle();

    // Fully restored!
    expect(state.totalFamilyAssets, equals(initialFamilyWealth));
  });

  testWidgets('Single profile switch location in Settings screen works cleanly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const FamilyAssetTrackerApp());

    // Login as Krish (Father)
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Navigate to Settings
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // Verify exactly ONE 'Switch Family Member Profile' button exists in Settings
    final switchBtn = find.text('Switch Family Member Profile');
    expect(switchBtn, findsOneWidget);

    await tester.scrollUntilVisible(switchBtn, 200);
    await tester.pumpAndSettle();
    await tester.tap(switchBtn);
    await tester.pumpAndSettle();

    // Select Abhishek (Child 2)
    final abhishekOption = find.descendant(
      of: find.byType(BottomSheet),
      matching: find.textContaining('Abhishek (Child 2)'),
    );
    expect(abhishekOption, findsOneWidget);
    await tester.tap(abhishekOption);
    await tester.pumpAndSettle();

    // Verify active profile switched in real-time to Abhishek (Child 2)
    expect(AppState().userName, contains('Abhishek (Child 2)'));
  });

  testWidgets('Holdings screen member filter option identifies current user account with (Self)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const FamilyAssetTrackerApp());

    // Login as Krish (Father)
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Navigate to Holdings tab
    await tester.tap(find.byIcon(Icons.bar_chart_outlined));
    await tester.pumpAndSettle();

    // Tap member dropdown filter
    await tester.tap(find.text('All Members'));
    await tester.pumpAndSettle();

    // Verify current user account is clearly identified with (Self)
    expect(find.text('Krish (Father) (Self)'), findsWidgets);

    // Select Krish (Father) (Self)
    await tester.tap(find.text('Krish (Father) (Self)').last);
    await tester.pumpAndSettle();

    // Verify all displayed holdings belong to Krish
    final state = AppState();
    final krishHoldingsCount = state.holdings.where((h) => AppState.isOwnerMatch(h.owner, 'Krish (Father)')).length;
    expect(find.text('Holdings ($krishHoldingsCount)'), findsOneWidget);
  });
}
