import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common/app_bar.dart';
import '../widgets/terms/term_table.dart';
import '../services/detection_service.dart';
import '../services/glossary_service.dart';

class ReviewTermsScreen extends StatelessWidget {
  const ReviewTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final detectionService = Provider.of<DetectionService>(context);
    final glossaryService = Provider.of<GlossaryService>(context);

    return Scaffold(
      appBar: const GlossaryAppBar(title: 'Review AI-detected terms'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'We found potential terms in your content that could be added to your glossary. Review the suggestions below, check the ones you want to include, and click "Add to glossary" when ready.',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(
                  child: TabBar(
                    tabs: [
                      Tab(text: 'Terms'),
                      Tab(text: 'AI suggestions'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TermTable(
                terms: detectionService.detectedTerms,
                onDoNotTranslateToggle: (term, value) {},
                onCaseSensitiveToggle: (term, value) {},
                onAddTerm: (term) {
                  glossaryService.addTerm(term);
                },
                onRejectTerm: (term) {
                  // Remove term from suggestions
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Reject all and start detection over
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reject all and start AI detection over'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}