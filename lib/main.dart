import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth_screens.dart';
import 'theme/hdfc_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const FamilyAssetTrackerApp());
}

class FamilyAssetTrackerApp extends StatelessWidget {
  const FamilyAssetTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HDFC Bank - Family Asset Tracker',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: HdfcColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: HdfcColors.navy,
          primary: HdfcColors.navy,
          secondary: HdfcColors.red,
          surface: HdfcColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: HdfcColors.textDark,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: HdfcColors.textDark,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: HdfcColors.navy,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: HdfcColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: HdfcColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: HdfcColors.navy, width: 1.5),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
