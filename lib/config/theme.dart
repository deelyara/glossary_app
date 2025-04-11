import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart'; // Ensure GoogleFonts is imported if needed for default themes
import 'colors.dart'; // Import the new ColorUtils

// Create a compatibility class to bridge the transition from AppTheme to ColorUtils
@Deprecated('Use ColorUtils instead')
class AppTheme {
  // Direct mappings to the static values for backward compatibility
  static const Color primaryColor = ColorUtils.primaryColorValue;
  static const Color secondaryColor = ColorUtils.secondaryColorValue;
  static const Color accentColor = ColorUtils.accentColorValue;

  // Text colors
  static const Color textPrimaryColor = ColorUtils.textPrimaryColorValue;
  static const Color textSecondaryColor = ColorUtils.textSecondaryColorValue;
  static const Color textTertiaryColor = ColorUtils.textTertiaryColorValue;
  
  // Status colors
  static const Color errorColor = ColorUtils.errorColorValue;
  static const Color successColor = ColorUtils.successColorValue;
  static const Color warningColor = ColorUtils.warningColorValue;
  
  // Background colors
  static const Color backgroundColor = ColorUtils.backgroundColorValue;
  static const Color surfaceColor = ColorUtils.surfaceColorValue;
}

// Helper function to convert hex string to Color object
Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  // Handle short hex codes if necessary
  if (hexCode.length == 6) {
    return Color(int.parse('FF$hexCode', radix: 16));
  } else if (hexCode.length == 8) {
      return Color(int.parse(hexCode, radix: 16)); // If alpha is included
  } else {
    // Return a default color or throw an error for invalid format
    debugPrint('Invalid hex color format: $hexColor');
    return Colors.transparent; // Default fallback
  }
}

// Function to create ColorScheme from a map of color strings
ColorScheme _createColorSchemeFromMap(Map<String, dynamic> colorMap) {
  final brightness = colorMap['brightness'] == 'dark' ? Brightness.dark : Brightness.light;
  
  return ColorScheme(
    brightness: brightness,
    primary: _colorFromHex(colorMap['primary']!),
    onPrimary: _colorFromHex(colorMap['onPrimary']!),
    primaryContainer: _colorFromHex(colorMap['primaryContainer']!),
    onPrimaryContainer: _colorFromHex(colorMap['onPrimaryContainer']!),
    secondary: _colorFromHex(colorMap['secondary']!),
    onSecondary: _colorFromHex(colorMap['onSecondary']!),
    secondaryContainer: _colorFromHex(colorMap['secondaryContainer']!),
    onSecondaryContainer: _colorFromHex(colorMap['onSecondaryContainer']!),
    tertiary: _colorFromHex(colorMap['tertiary']!),
    onTertiary: _colorFromHex(colorMap['onTertiary']!),
    tertiaryContainer: _colorFromHex(colorMap['tertiaryContainer']!),
    onTertiaryContainer: _colorFromHex(colorMap['onTertiaryContainer']!),
    error: _colorFromHex(colorMap['error']!),
    onError: _colorFromHex(colorMap['onError']!),
    errorContainer: _colorFromHex(colorMap['errorContainer']!),
    onErrorContainer: _colorFromHex(colorMap['onErrorContainer']!),
    background: _colorFromHex(colorMap['background']!),
    onBackground: _colorFromHex(colorMap['onBackground']!),
    surface: _colorFromHex(colorMap['surface']!),
    onSurface: _colorFromHex(colorMap['onSurface']!),
    surfaceVariant: _colorFromHex(colorMap['surfaceVariant']!),
    onSurfaceVariant: _colorFromHex(colorMap['onSurfaceVariant']!),
    outline: _colorFromHex(colorMap['outline']!),
    outlineVariant: _colorFromHex(colorMap['outlineVariant']!),
    shadow: _colorFromHex(colorMap['shadow'] ?? '#000000'),
    scrim: _colorFromHex(colorMap['scrim'] ?? '#000000'),
    surfaceTint: _colorFromHex(colorMap['surfaceTint']!),
  );
}

// Main function to load color schemes from the JSON asset
Future<Map<String, ColorScheme>> loadColorSchemesFromJson(String assetPath) async {
  try {
    final String jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final Map<String, ColorScheme> colorSchemes = {};

    if (jsonMap.containsKey('light') && jsonMap['light'] is Map) {
      final lightMap = Map<String, dynamic>.from(jsonMap['light']);
      lightMap['brightness'] = 'light'; // Add brightness info
      colorSchemes['light'] = _createColorSchemeFromMap(lightMap);
    }

    if (jsonMap.containsKey('dark') && jsonMap['dark'] is Map) {
      final darkMap = Map<String, dynamic>.from(jsonMap['dark']);
      darkMap['brightness'] = 'dark'; // Add brightness info
      colorSchemes['dark'] = _createColorSchemeFromMap(darkMap);
    }

    if (colorSchemes.isEmpty) {
      debugPrint('Warning: No valid light or dark theme found in $assetPath. Using default themes.');
      return _defaultColorSchemes();
    }
    // Use default if one theme is missing
    if (!colorSchemes.containsKey('light')) {
      debugPrint('Warning: Light theme missing in $assetPath. Using default light theme.');
      colorSchemes['light'] = ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light);
    }
    if (!colorSchemes.containsKey('dark')) {
      debugPrint('Warning: Dark theme missing in $assetPath. Using default dark theme.');
      colorSchemes['dark'] = ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);
    }

    return colorSchemes;
  } catch (e) {
    debugPrint('Error loading color schemes from $assetPath: $e. Using default themes.');
    return _defaultColorSchemes();
  }
}

// Helper to return default fallback themes
Map<String, ColorScheme> _defaultColorSchemes() {
  const seedColor = Colors.blue; // Or your preferred default seed
  return {
    'light': ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light),
    'dark': ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark),
  };
}

// No longer need the AppTheme class or static ThemeData definitions
// class AppTheme { ... }