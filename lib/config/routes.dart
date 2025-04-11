import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/detect_terms_screen.dart';
import '../screens/review_terms_screen.dart';
import '../screens/main_glossary_screen.dart';

class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String mainGlossary = '/';
  static const String detectTerms = '/detect-terms';
  static const String reviewTerms = '/review-terms';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      mainGlossary: (context) => const MainGlossaryScreen(),
      dashboard: (context) => const DashboardScreen(),
      detectTerms: (context) => const DetectTermsScreen(),
      reviewTerms: (context) => const ReviewTermsScreen(),
    };
  }
}