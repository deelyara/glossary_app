import 'package:flutter/material.dart';
import '../../config/colors.dart';

class DetectionProgressBanner extends StatelessWidget {
  const DetectionProgressBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Define consistent styling based on DetectionFinishedBanner
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    const EdgeInsets margin = EdgeInsets.only(top: 8.0, bottom: 8.0, left: 24.0, right: 24.0);
    final BorderRadius borderRadius = BorderRadius.circular(12);
    
    // Use primary container colors from the theme for "info" style
    final backgroundColor = colorScheme.primaryContainer;
    final textColor = colorScheme.onPrimaryContainer;
    final borderColor = colorScheme.primary.withOpacity(0.3);

    return Container(
      // Apply consistent margin and padding
      margin: margin,
      padding: padding,
      // Apply consistent decoration (shape, border, background)
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: textColor, 
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI detection in progress',
                  style: textTheme.titleSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Feel free to navigate away, we will send you notifications when it finishes',
                  style: textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          // Add a loading indicator
          SizedBox(
            width: 16, height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2, 
              color: textColor,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          )
        ],
      ),
    );
  }
} 