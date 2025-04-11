import 'package:flutter/material.dart';

/// Provides color constants and utilities for consistent styling across the app
/// This replaces the previous AppTheme static colors with theme-aware alternatives
class ColorUtils {
  // Static constants for const contexts (e.g., const Text(color: ColorUtils.primaryColorValue))
  // These should match the colors in your theme
  static const Color primaryColorValue = Color(0xFF37618E);
  static const Color secondaryColorValue = Color(0xFF37618E);
  static const Color accentColorValue = Color(0xFF88521C);
  
  // Text colors
  static const Color textPrimaryColorValue = Color(0xFF191C20);
  static const Color textSecondaryColorValue = Color(0xFF43474E);
  static const Color textTertiaryColorValue = Color(0xFF73777F);
  
  // Status colors
  static const Color errorColorValue = Color(0xFF904A42);
  static const Color successColorValue = Color(0xFF4CAF50); // Green
  static const Color warningColorValue = Color(0xFFFFA726); // Orange
  
  // Background colors
  static const Color backgroundColorValue = Color(0xFFF8F9FF);
  static const Color surfaceColorValue = Color(0xFFF8F9FF);

  // Dynamic methods that use the theme context
  // Static method to get the primary color from the current theme
  static Color primaryColor(BuildContext context) => Theme.of(context).colorScheme.primary;
  
  // Static method to get the secondary color from the current theme
  static Color secondaryColor(BuildContext context) => Theme.of(context).colorScheme.secondary;
  
  // Static method to get the accent color from the current theme
  static Color accentColor(BuildContext context) => Theme.of(context).colorScheme.tertiary;

  // Text colors
  static Color textPrimaryColor(BuildContext context) => Theme.of(context).colorScheme.onSurface;
  static Color textSecondaryColor(BuildContext context) => Theme.of(context).colorScheme.onSurfaceVariant;
  static Color textTertiaryColor(BuildContext context) => Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7);

  // Status colors
  static Color errorColor(BuildContext context) => Theme.of(context).colorScheme.error;
  static Color successColor(BuildContext context) => successColorValue;
  static Color warningColor(BuildContext context) => warningColorValue;

  // Background colors
  static Color backgroundColor(BuildContext context) => Theme.of(context).colorScheme.background;
  static Color surfaceColor(BuildContext context) => Theme.of(context).colorScheme.surface;

  // Get a color based on relevance (for term display)
  static Color getRelevanceColor(BuildContext context, String relevance) {
    switch (relevance.toLowerCase()) {
      case 'high':
        return successColor(context);
      case 'medium':
        return primaryColor(context);
      case 'low':
        return warningColor(context);
      default:
        return primaryColor(context);
    }
  }
} 