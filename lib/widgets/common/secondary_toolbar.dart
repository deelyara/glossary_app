import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// A secondary toolbar widget that appears below the main app bar.
/// It provides additional tools and functionality for working with glossary terms.
class SecondaryToolbar extends StatelessWidget {
  final List<Widget>? actions;

  const SecondaryToolbar({
    super.key,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Standard button style for toolbar buttons
    final ButtonStyle toolbarButtonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(0, 36), // Slightly smaller height for secondary toolbar
      backgroundColor: colorScheme.surface,
      foregroundColor: AppTheme.textPrimaryColor,
      side: BorderSide(color: Colors.grey.shade300),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      textStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
    );

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: actions ?? [
          // Default items if no actions provided
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Detect terms'),
            style: toolbarButtonStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(AppTheme.primaryColor),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, size: 18),
            label: const Text('Filter'),
            style: toolbarButtonStyle,
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sort, size: 18),
            label: const Text('Sort'),
            style: toolbarButtonStyle,
          ),
          const Spacer(),
          Text(
            'Tools:',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.help_outline,
              color: AppTheme.textSecondaryColor,
              size: 20,
            ),
            tooltip: 'Help',
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: AppTheme.textSecondaryColor,
              size: 20,
            ),
            tooltip: 'Settings',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
} 