import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dishant_dash_hdfc_hackathon_2026/main.dart';
import 'package:dishant_dash_hdfc_hackathon_2026/models/app_state.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Full hackathon flow test', (WidgetTester tester) async {
    await tester.pumpWidget(const FamilyAssetTrackerApp());

    // 1. Welcome Screen
    expect(find.text('Family Asset Tracker'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // 2. Login Screen -> Press Login -> goes to Main Navigation
    expect(find.text('Welcome Back!'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // 3. Home Screen
    expect(find.text('Krish (Father)'), findsWidgets);
    expect(find.text('My Personal Assets'), findsOneWidget);
    expect(find.text('Asset Allocation'), findsOneWidget);

    // 4. Tap Holdings tab
    await tester.tap(find.byIcon(Icons.bar_chart_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Holding'), findsOneWidget);

    // 5. Tap Settings tab
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Share My Profile'), findsOneWidget);
    expect(find.text('Manage Asset Types'), findsOneWidget);

    // 6. Test Profile Sharing
    await tester.tap(find.text('Share My Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Member Details'), findsOneWidget);
    await tester.tap(find.text('Share My Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Family Members'), findsOneWidget);

    // Toggle switch
    final switches = find.byType(Switch);
    expect(switches, findsWidgets);
    await tester.tap(switches.first);
    await tester.pump();
    expect(find.text('Visibility settings updated successfully.'), findsOneWidget);

    // Back to Settings
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new).last);
    await tester.pumpAndSettle();

    // 7. Test Manage Asset Types
    await tester.tap(find.text('Manage Asset Types'));
    await tester.pumpAndSettle();
    expect(find.text('Asset Types'), findsOneWidget);
    expect(find.text('Equity'), findsOneWidget);

    // Tap Equity to view items
    await tester.tap(find.text('Equity'));
    await tester.pumpAndSettle();
    expect(find.text('AAPL'), findsOneWidget);

    // Tap + to add item
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Add Item'), findsOneWidget);

    final saveButton = find.widgetWithText(ElevatedButton, 'Save');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('Item Added Successfully!'), findsOneWidget);

    // Tap Done
    await tester.tap(find.widgetWithText(ElevatedButton, 'Done'));
    await tester.pumpAndSettle();
    expect(find.text('HDFCBANK'), findsOneWidget);
  });

  testWidgets('Signup validation and OTP verification flow into Home', (WidgetTester tester) async {
    await tester.pumpWidget(const FamilyAssetTrackerApp());

    // Tap Sign Up
    await tester.tap(find.widgetWithText(OutlinedButton, 'Sign Up'));
    await tester.pumpAndSettle();
    expect(find.text('Create Your Account'), findsOneWidget);

    // Tap Sign Up with prefilled data -> opens OTP dialog
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pumpAndSettle();
    expect(find.text('Verify Mobile OTP'), findsOneWidget);

    // Tap Verify & Create Account with valid OTP
    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify & Create Account'));
    await tester.pumpAndSettle();
    expect(find.text('Account Created Successfully!'), findsOneWidget);

    // Continue to Home
    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pumpAndSettle();
    expect(find.text('My Personal Assets'), findsOneWidget);
  });

  testWidgets('Member options: My Holdings, Edit Profile, Remove Member, and Settings Logout flow', (WidgetTester tester) async {
    await tester.pumpWidget(const FamilyAssetTrackerApp());

    // Login directly
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Go to Settings
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // Tap Share My Profile -> Member Details
    await tester.tap(find.text('Share My Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Member Details'), findsOneWidget);

    // 1. Test "My Holdings"
    await tester.tap(find.text('My Holdings'));
    await tester.pumpAndSettle();
    expect(find.text("Krish (Father)'s Holdings"), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();

    // 2. Test "Edit Profile"
    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Member Profile'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save Changes'));
    await tester.pumpAndSettle();
    expect(find.text('Member profile for Krish (Father) updated successfully!'), findsOneWidget);

    // 3. Back to Settings
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();

    // 4. Test Switch Profile
    await tester.scrollUntilVisible(find.text('Switch Family Member Profile'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Switch Family Member Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Switch Member Profile'), findsOneWidget);
    await tester.tap(find.descendant(of: find.byType(BottomSheet), matching: find.textContaining('Trish (Mother)')));
    await tester.pumpAndSettle();

    // 5. Test Logout and Login with another family member (Trish (Mother))
    await tester.scrollUntilVisible(find.widgetWithText(OutlinedButton, 'Logout'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Are you sure you want to log out of your HDFC Family Asset Tracker account?'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Family Asset Tracker'), findsOneWidget);

    // 6. Test logging in as Trish (Mother)
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Quick Family Account Login (PIN: 1234)'), findsOneWidget);
    await tester.tap(find.text('Trish (Mother)'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Trish (Mother)'), findsWidgets);
  });

  testWidgets('Real-time asset editing, deletion, and family member addition across sessions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const FamilyAssetTrackerApp());

    // 1. Login as Shiva Guru (Self)
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // 2. Go to Settings -> Tap + Add Member
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('+ Add Member'), findsOneWidget);

    await tester.tap(find.text('+ Add Member'));
    await tester.pumpAndSettle();
    expect(find.text('Add Family Member'), findsWidgets);

    // Fill form for new member "Rohan Guru" (Brother)
    await tester.enterText(find.widgetWithText(TextField, 'e.g. Rohan Guru'), 'Rohan Guru');
    await tester.enterText(find.widgetWithText(TextField, 'e.g. 9876543215'), '9876543215');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Family Member'));
    await tester.pumpAndSettle();
    expect(find.text('Rohan Guru (Son) added to Family Circle!'), findsOneWidget);

    // Dismiss any snackbar
    ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first)).clearSnackBars();
    await tester.pumpAndSettle();

    // 3. Go to Holdings -> Check asset editing
    await tester.tap(find.text('Holdings'));
    await tester.pumpAndSettle();
    expect(find.text('Holding'), findsOneWidget);

    // Open popup menu on first holding
    final moreButtons = find.byIcon(Icons.more_horiz);
    expect(moreButtons, findsWidgets);
    await tester.tap(moreButtons.first);
    await tester.pumpAndSettle();
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    // Tap Edit
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Holding'), findsOneWidget);

    final saveBtn = find.widgetWithText(ElevatedButton, 'Save Changes');
    await tester.ensureVisible(saveBtn);
    await tester.pumpAndSettle();
    await tester.tap(saveBtn);
    await tester.pumpAndSettle();
    expect(find.textContaining('updated in family portfolio!'), findsOneWidget);

    // 4. Switch profile to Trish (Mother)
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Switch Family Member Profile'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Switch Family Member Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(BottomSheet), matching: find.textContaining('Trish (Mother)')));
    await tester.pumpAndSettle();

    // Verify Trish (Mother) is now active
    expect(AppState().userName, contains('Trish (Mother)'));

    // 5. Go to Holdings -> Delete an asset
    await tester.tap(find.text('Holdings'));
    await tester.pumpAndSettle();
    final countBefore = AppState().holdings.length;
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(AppState().holdings.length, countBefore - 1);
    expect(find.textContaining('removed from family holdings!'), findsOneWidget);

    // 6. Logout and login with newly added family member
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.widgetWithText(OutlinedButton, 'Logout'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Logout'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logout'));
    await tester.pumpAndSettle();

    // Welcome Screen -> Login
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Verify Rohan Guru appears in quick account login chips!
    final rohanChip = find.textContaining('Rohan Guru');
    expect(rohanChip, findsOneWidget);
    await tester.ensureVisible(rohanChip);
    await tester.pumpAndSettle();
    await tester.tap(rohanChip);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Verify logged in as Rohan Guru
    expect(AppState().userName, contains('Rohan Guru'));
  });
}
