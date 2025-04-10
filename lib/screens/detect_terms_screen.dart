import 'package:flutter/material.dart';
import '../widgets/common/app_bar.dart';
import '../widgets/detection/detection_modal.dart';

class DetectTermsScreen extends StatelessWidget {
  const DetectTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlossaryAppBar(title: 'Detect Terms'),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => DetectionModal(
                onCancel: () => Navigator.pop(context),
                onStartDetection: () {
                  Navigator.pop(context);
                  // Start detection
                },
              ),
            );
          },
          child: const Text('Start AI Detection'),
        ),
      ),
    );
  }
}