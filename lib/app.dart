// lib/app.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'config/routes.dart';
import 'config/theme.dart';

class GlossaryApp extends StatelessWidget {
  const GlossaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create standard themes
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
      textTheme: GoogleFonts.notoSansTextTheme(ThemeData.light().textTheme),
    );

    final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      useMaterial3: true,
      textTheme: GoogleFonts.notoSansTextTheme(ThemeData.dark().textTheme),
    );

    return MaterialApp(
      title: 'Easyling',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light, // Or ThemeMode.dark or ThemeMode.system
      routes: AppRoutes.getRoutes(),
      initialRoute: AppRoutes.mainGlossary,
      debugShowCheckedModeBanner: false,
    );
  }
}