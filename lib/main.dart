import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'config/env/dev_env.dart';
import 'config/env/prod_env.dart';
import 'config/env/staging_env.dart';
import 'package:flutter/foundation.dart';
import 'services/http_client.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable hardware acceleration on Android only in debug mode
  if (Platform.isAndroid && kDebugMode) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  }

  // Initialize environment based on build configuration
  if (kReleaseMode) {
    initProdEnvironment();
  } else if (const bool.fromEnvironment('STAGING')) {
    initStagingEnvironment();
  } else {
    initDevEnvironment();
  }

  // Initialize HTTP client
  await HttpClient().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VunaBoda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5DD3),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Color(0xFF4C3FF7),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: const Color(0xFF4C3FF7),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
