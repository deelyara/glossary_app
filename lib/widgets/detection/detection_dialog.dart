import 'package:flutter/material.dart';

class DetectionDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onStartDetection;

  const DetectionDialog({
    super.key,
    required this.onCancel,
    required this.onStartDetection,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // M3 Dialog shape
      titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0), // Adjust title padding
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0), // Adjust content padding
      actionsPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0), // Adjust actions padding
      title: const Text('Detect glossary terms with AI'),
      titleTextStyle: textTheme.titleLarge, // M3 Dialog title style
      content: Text(
        'This method will detect potential relevant terms for your glossary based on your content and will recommend candidates',
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant), // M3 Dialog content style
      ),
      actions: <Widget>[
        // Cancel Button (Outlined style)
        TextButton(
          style: TextButton.styleFrom(
             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Pill shape
             side: BorderSide(color: Colors.grey.shade400), // Outline
          ),
          child: const Text('Cancel'),
          onPressed: onCancel,
        ),
        const SizedBox(width: 8), // Gap between buttons
        // Start Detection Button (Filled style)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Pill shape
            elevation: 0,
          ),
          child: const Text('Start detection'),
          onPressed: onStartDetection,
        ),
      ],
    );
  }
} 