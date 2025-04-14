import 'package:flutter/material.dart';

class DetectionSecondRunBanner extends StatelessWidget {
  final VoidCallback onDismiss;

  const DetectionSecondRunBanner({
    super.key,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    // Light blue background color matching the image
    final backgroundColor = const Color(0xFFD1E4FF);
    final textColor = const Color(0xFF1A365D);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 24.0, right: 24.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review AI-detected terms',
                  style: textTheme.titleSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We found potential terms in your content that could be added to your glossary. Already added terms won\'t show up in this list. Review the suggestions below, add the ones you want to include.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: textColor),
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 24,
          ),
        ],
      ),
    );
  }
} 