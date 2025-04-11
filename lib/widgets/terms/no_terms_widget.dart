import 'package:flutter/material.dart';
import '../../config/colors.dart';

class NoTermsWidget extends StatelessWidget {
  final VoidCallback onDetectTerms;
  final VoidCallback? onTranslate;

  const NoTermsWidget({
    super.key,
    required this.onDetectTerms,
    this.onTranslate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
          left: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.list_alt_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  'There are no more term candidates to review',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.textPrimaryColorValue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Run again if you\'ve added new content to your website.',
                  style: const TextStyle(
                    color: ColorUtils.textSecondaryColorValue,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: onDetectTerms,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Detect terms'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorUtils.primaryColorValue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              if (onTranslate != null) ...[
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: onTranslate,
                  icon: const Icon(Icons.translate),
                  label: const Text('Translate'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorUtils.textPrimaryColorValue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
} 