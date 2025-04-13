import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_flags/country_flags.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/term.dart';
import '../services/glossary_service.dart';
import '../services/detection_service.dart';
import '../widgets/common/left_sidebar.dart';
import '../widgets/common/right_sidebar.dart';
import '../widgets/detection/detection_dialog.dart';
import '../widgets/detection/detection_progress_banner.dart';
import '../widgets/detection/detection_finished_banner.dart';
import '../config/colors.dart';

// Helper method to build the terms table
Widget buildTermsTable(
  BuildContext context, 
  GlossaryService glossaryService, 
  ColorScheme colorScheme, 
  TextTheme textTheme, 
  String searchQuery, 
  Set<String> selectedTermIds,
  Function(String termId, bool? isSelected) onTermSelectedToggle,
) {
  // Filter terms based on search query
  final filteredTerms = searchQuery.isEmpty 
      ? glossaryService.allTerms 
      : glossaryService.allTerms.where(
          (term) => term.text.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
  
  return filteredTerms.isEmpty 
    ? Center(
        child: searchQuery.isNotEmpty 
          ? Text("No terms found matching '$searchQuery'", style: textTheme.bodyMedium)
          : Text("No terms in glossary.", style: textTheme.bodyMedium)
      ) 
    : SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
        child: Column(
          children: List.generate(
            filteredTerms.length,
            (index) {
              final term = filteredTerms[index];
              
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outline.withOpacity(0.1)),
                  ),
                ),
                child: Row(
                  children: [
                    // Checkbox
                    SizedBox(
                      width: 40,
                      child: Checkbox(
                        value: selectedTermIds.contains(term.id),
                        onChanged: (value) {
                          onTermSelectedToggle(term.id, value);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    // Term column
                    Expanded(
                      flex: 2,
                      child: Text(
                        term.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // Translation column
                    Expanded(
                      flex: 2,
                      child: Text(
                        term.translation ?? 'This term is not translatable',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          fontStyle: term.translation == null ? FontStyle.italic : FontStyle.normal,
                          color: term.translation == null ? Colors.grey.shade600 : ColorUtils.textPrimaryColor(context),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Confirmed column (centered)
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Checkbox(
                          value: term.confirmed,
                          onChanged: (value) {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                    // Example column
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (term.examples.isEmpty)
                            const Text(
                              '-',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )
                          else
                            ...term.examples.map((example) => Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                example,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )).toList(),
                        ],
                      ),
                    ),
                    // Actions column
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            // TODO: Implement action menu (edit, delete, etc.)
                          },
                          iconSize: 20,
                          splashRadius: 20,
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Actions',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
}

// Helper method to build the AI suggestions table
Widget buildAISuggestionsTable(
  BuildContext context, 
  GlossaryService glossaryService, 
  ColorScheme colorScheme, 
  TextTheme textTheme, 
  String searchQuery,
  Map<String, Set<int>> selectedExamples,
  Set<String> selectedTermIds,
  Function(String, int, bool?) onExampleToggle,
  Function(String, bool?) onTermSelectedToggle,
  VoidCallback onTermAccepted,
  VoidCallback onDetectPressed,
) {
  // Filter AI suggestions based on search query
  final filteredTerms = searchQuery.isEmpty 
      ? glossaryService.aiSuggestedTerms 
      : glossaryService.aiSuggestedTerms.where(
          (term) => term.text.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
  
  if (filteredTerms.isEmpty && searchQuery.isEmpty) {
    // Return the empty state if there are no suggestions and no search
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0), // Increased horizontal padding to at least 16px
      child: _buildEmptyAISuggestionsState(context, colorScheme, textTheme, onDetectPressed),
    );
  }

  return filteredTerms.isEmpty && searchQuery.isNotEmpty 
    ? Center(child: Text("No suggestions found matching '$searchQuery'", style: textTheme.bodyMedium))
    : SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
        child: Column(
          children: List.generate(
            filteredTerms.length,
            (index) {
              final term = filteredTerms[index];
              
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outline.withOpacity(0.1)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Checkbox for term selection
                        SizedBox(
                          width: 40,
                          child: Checkbox(
                            value: selectedTermIds.contains(term.id),
                            onChanged: (value) {
                              onTermSelectedToggle(term.id, value);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),

                        // Term column
                        Expanded(
                          flex: 2,
                          child: Text(
                            term.text,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        
                        // Usage score - aligned with its column
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              '${term.usageScore.toInt()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        
                        // Do Not Translate toggle switch
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: term.doNotTranslate,
                                onChanged: (value) {
                                  final updatedTerm = term.copyWith(doNotTranslate: value);
                                  final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                  glossaryService.updateAISuggestion(updatedTerm);
                                },
                                activeColor: colorScheme.primary,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                        ),
                        
                        // Case Sensitive toggle switch
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: term.caseSensitive,
                                onChanged: (value) {
                                  final updatedTerm = term.copyWith(caseSensitive: value);
                                  final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                  glossaryService.updateAISuggestion(updatedTerm);
                                },
                                activeColor: colorScheme.primary,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                        ),
                        
                        // Add more space between toggles and examples
                        const SizedBox(width: 16),
                        
                        // Examples section
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select examples to include:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...term.examples.take(3).map((example) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: selectedExamples.containsKey(term.id) && 
                                                selectedExamples[term.id]!.contains(term.examples.indexOf(example)),
                                          onChanged: (value) {
                                            // Call the callback to handle example toggling
                                            onExampleToggle(term.id, term.examples.indexOf(example), value);
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              example,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'Found on: dogs/boci/',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        
                        // Actions column (with Accept and Reject buttons)
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Add button
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  // Get selected examples for this term
                                  final selectedExampleIndices = selectedExamples[term.id] ?? {};
                                  
                                  // Create a list of the selected examples
                                  final selectedExampleTexts = selectedExampleIndices
                                      .map((index) => term.examples[index])
                                      .toList();
                                  
                                  // Create a new term with only the selected examples
                                  final termToAdd = term.copyWith(
                                    examples: selectedExampleTexts.isEmpty 
                                        ? [] // If no examples selected, add empty list
                                        : selectedExampleTexts,
                                  );
                                  
                                  // Add term to glossary
                                  final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                  glossaryService.acceptAISuggestion(termToAdd);
                                  
                                  // Call the callback to notify the parent screen
                                  onTermAccepted();
                                },
                                tooltip: 'Add to glossary',
                                iconSize: 20,
                                color: colorScheme.primary,
                              ),
                              // Reject button
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  // Reject the term suggestion
                                  final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                  glossaryService.rejectAISuggestion(term);
                                },
                                tooltip: 'Reject term',
                                iconSize: 20,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
}

// Helper widget for the empty AI Suggestions state
Widget _buildEmptyAISuggestionsState(BuildContext context, ColorScheme colorScheme, TextTheme textTheme, VoidCallback onDetectPressed) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Reduced vertical padding
    decoration: BoxDecoration(
      border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(12),
      color: colorScheme.surface,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center, // Ensure vertical centering
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              Text(
                'There are no more term candidates to review',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2), // Reduced spacing between lines
              Text(
                'Run again if you\'ve added new content to your website.',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        FilledButton.icon(
          onPressed: onDetectPressed,
          icon: const Icon(Icons.auto_awesome_outlined, size: 18),
          label: const Text('Detect terms'),
          style: FilledButton.styleFrom(
            foregroundColor: colorScheme.onPrimary,
            backgroundColor: colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), // Slightly reduced button padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
} 