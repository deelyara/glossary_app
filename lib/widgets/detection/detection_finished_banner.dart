import 'package:flutter/material.dart';
import '../../config/routes.dart'; // Import routes for navigation
import '../../config/colors.dart';

class DetectionFinishedBanner extends StatelessWidget {
  // Optional: Pass the number of found terms if needed
  final int termCount;
  final VoidCallback? onReviewCandidates;

  const DetectionFinishedBanner({
    super.key,
    this.termCount = 50, // Default based on image text
    this.onReviewCandidates,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    // Use the specific success color requested
    final backgroundColor = const Color(0xFFCFEBCB); // Light green background
    final textColor = const Color(0xFF2E5029); // Dark green text
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      margin: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 24.0, right: 24.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI detection finished',
                  style: textTheme.titleSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We found potential terms in your content. Click "Review candidates" to start adding them to your glossary.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          FilledButton(
            onPressed: onReviewCandidates,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            child: const Text('Review candidates'),
          ),
        ],
      ),
    );
  }
} 