// lib/widgets/detection/detection_modal.dart
import 'package:flutter/material.dart';
import '../../config/theme.dart'; // Keep for potential custom colors if needed

class DetectionModal extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onStartDetection;

  const DetectionModal({
    super.key,
    required this.onCancel,
    required this.onStartDetection,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Button styles consistent with dashboard empty states
    final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.primaryColor, // Use app theme's primary color
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0, // Match other buttons
    );
     final ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      side: BorderSide(color: Colors.grey.shade300),
      foregroundColor: AppTheme.textPrimaryColor, // Use app theme's text color
      textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Slightly smaller radius for consistency perhaps
      ),
      surfaceTintColor: colorScheme.surfaceTint,
      titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      actionsPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
      title: Text(
        'Detect glossary terms with AI',
        style: textTheme.headlineSmall, // Use M3 style for title
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'This will scan your content to find potential glossary terms and suggest candidates for review.',
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        // Use OutlinedButton for Cancel, matching secondary actions
        OutlinedButton(
          onPressed: onCancel,
          style: secondaryButtonStyle,
          child: const Text('Cancel'),
        ),
        // Use ElevatedButton for Start Detection, matching primary actions
        ElevatedButton(
          onPressed: onStartDetection,
          style: primaryButtonStyle,
          child: const Text('Start detection'),
        ),
      ],
    );
  }
}

// Note: To make this appear as a BottomSheet (as it was used in dashboard_screen),
// you would wrap the content Column in a Container/Padding and use showModalBottomSheet.
// Example usage with showModalBottomSheet:
/*
void _showDetectionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Important for content height
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
    ),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4, // Adjust initial size as needed
      minChildSize: 0.2,
      maxChildSize: 0.6,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (e.g., centered drag handle)
              Center(
                child: Container(
                  height: 4,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                'Detect glossary terms with AI',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                'This will scan your content to find potential glossary terms and suggest candidates for review.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context), // Use Navigator.pop for bottom sheet
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context); // Close sheet
                      // Call the actual detection start function (passed via constructor)
                      // onStartDetection();
                    },
                    child: const Text('Start detection'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
*/