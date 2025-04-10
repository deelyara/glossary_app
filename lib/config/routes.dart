import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/detect_terms_screen.dart';
import '../screens/review_terms_screen.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String detectTerms = '/detect-terms';
  static const String reviewTerms = '/review-terms';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      dashboard: (context) => const DashboardScreen(),
      detectTerms: (context) => const DetectTermsScreen(),
      reviewTerms: (context) => const ReviewTermsScreen(),
    };
  }
}