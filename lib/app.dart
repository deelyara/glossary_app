// lib/app.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'config/routes.dart';

class GlossaryApp extends StatelessWidget {
  final ColorScheme lightColorScheme;
  final ColorScheme darkColorScheme;

  const GlossaryApp({
    super.key,
    required this.lightColorScheme,
    required this.darkColorScheme,
  });

  @override
  Widget build(BuildContext context) {
    // Create ThemeData from the loaded ColorSchemes
    final lightTheme = ThemeData(
      colorScheme: lightColorScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(ThemeData(brightness: Brightness.light).textTheme),
      // Add other theme customizations for light mode if needed
      // e.g., scaffoldBackgroundColor: lightColorScheme.background,
    );

    final darkTheme = ThemeData(
      colorScheme: darkColorScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
      // Add other theme customizations for dark mode if needed
      // e.g., scaffoldBackgroundColor: darkColorScheme.background,
    );

    // Note: MultiProvider is now in main.dart
    return MaterialApp(
      title: 'Easyling',
      theme: lightTheme, // Use generated light theme
      darkTheme: darkTheme, // Use generated dark theme
      themeMode: ThemeMode.light, // Or ThemeMode.dark or ThemeMode.system
      routes: AppRoutes.getRoutes(),
      initialRoute: AppRoutes.mainGlossary,
      debugShowCheckedModeBanner: false,
    );
  }
}