import '../config/colors.dart';

// MIGRATION GUIDE FOR REPLACING AppTheme WITH ColorUtils
//
// 1. In each file where AppTheme is used, add this import at the top:
//    import '../config/colors.dart';
//    (adjust the path as needed)
//
// 2. Replace all instances of AppTheme with ColorUtils, using these patterns:
//
//    For const contexts (e.g., const Text(...)):
//    Replace:  AppTheme.primaryColor  →  ColorUtils.primaryColorValue
//    Replace:  AppTheme.textPrimaryColor  →  ColorUtils.textPrimaryColorValue
//    Replace:  AppTheme.textSecondaryColor  →  ColorUtils.textSecondaryColorValue
//    Replace:  AppTheme.textTertiaryColor  →  ColorUtils.textTertiaryColorValue
//    Replace:  AppTheme.errorColor  →  ColorUtils.errorColorValue
//    Replace:  AppTheme.successColor  →  ColorUtils.successColorValue
//    Replace:  AppTheme.warningColor  →  ColorUtils.warningColorValue
//    Replace:  AppTheme.backgroundColor  →  ColorUtils.backgroundColorValue
//    Replace:  AppTheme.surfaceColor  →  ColorUtils.surfaceColorValue
//
//    For non-const contexts (where BuildContext is available):
//    Replace:  AppTheme.primaryColor  →  ColorUtils.primaryColor(context)
//    Replace:  AppTheme.textPrimaryColor  →  ColorUtils.textPrimaryColor(context)
//    Replace:  AppTheme.textSecondaryColor  →  ColorUtils.textSecondaryColor(context)
//    Replace:  AppTheme.textTertiaryColor  →  ColorUtils.textTertiaryColor(context)
//    Replace:  AppTheme.errorColor  →  ColorUtils.errorColor(context)
//    Replace:  AppTheme.successColor  →  ColorUtils.successColor(context)
//    Replace:  AppTheme.warningColor  →  ColorUtils.warningColor(context)
//    Replace:  AppTheme.backgroundColor  →  ColorUtils.backgroundColor(context)
//    Replace:  AppTheme.surfaceColor  →  ColorUtils.surfaceColor(context)
//
//    For MaterialStateProperty.all():
//    Replace:  MaterialStateProperty.all(AppTheme.primaryColor)
//             → MaterialStateProperty.all(ColorUtils.primaryColorValue)
//    (or use the context-based version if available)
//
// 3. After updating all files, run flutter clean and flutter pub get to ensure a clean build.
//
// IMPORTANT:
// - Determine if a context is needed based on whether the widget is const or not
// - Update all import paths correctly based on the file's location
// - Make sure to check for complex uses like .withOpacity() and handle them appropriately
//
// Example conversion:
//
// Before:
// ```
// Container(
//   color: AppTheme.primaryColor.withOpacity(0.5),
//   child: const Text(
//     'Hello',
//     style: TextStyle(color: AppTheme.textPrimaryColor),
//   ),
// )
// ```
//
// After:
// ```
// Container(
//   color: ColorUtils.primaryColor(context).withOpacity(0.5),
//   child: const Text(
//     'Hello',
//     style: TextStyle(color: ColorUtils.textPrimaryColorValue),
//   ),
// )
// ``` 