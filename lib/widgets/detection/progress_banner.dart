// lib/widgets/detection/progress_banner.dart
import 'package:flutter/material.dart';
import '../../config/theme.dart';

class ProgressBanner extends StatelessWidget {
  const ProgressBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Light blue background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBBDEFB)), // Slightly darker blue border
      ),
      child: Row(
        children: [
          // Animated progress indicator
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI detection in progress',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1976D2), // Darker blue text for header
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Feel free to navigate away, we will send you notifications when it finishes',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}