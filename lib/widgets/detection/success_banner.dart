// lib/widgets/detection/success_banner.dart
import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SuccessBanner extends StatelessWidget {
  final int termCount;
  final VoidCallback onReviewCandidates;

  const SuccessBanner({
    super.key,
    required this.termCount,
    required this.onReviewCandidates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // Light green background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC8E6C9)), // Slightly darker green border
      ),
      child: Row(
        children: [
          // Success icon
          const Icon(
            Icons.check_circle,
            color: Color(0xFF43A047), // Green success icon
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI detection finished',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF2E7D32), // Darker green text for header
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We found $termCount potential terms in your content. Click "Review candidates" to start adding them to your glossary.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: onReviewCandidates,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Review candidates',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}