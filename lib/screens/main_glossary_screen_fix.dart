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
                    // Term column - updated flex to 1 to match header
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          term.text,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Translation column
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          term.translation ?? 'This term is not translatable',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontStyle: term.translation == null ? FontStyle.italic : FontStyle.normal,
                            color: term.translation == null ? Colors.grey.shade600 : ColorUtils.textPrimaryColor(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (term.examples.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    term.examples[0],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                            else
                              Text(
                                'No examples available',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
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
    return _buildEmptyAISuggestionsState(context, colorScheme, textTheme, onDetectPressed);
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
                          child: Center(
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
                        ),

                        // Term column
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              term.text,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
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
                            child: Checkbox(
                              value: term.doNotTranslate,
                              onChanged: (value) {
                                final updatedTerm = term.copyWith(doNotTranslate: value ?? false);
                                final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                glossaryService.updateAISuggestion(updatedTerm);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                        
                        // Case Sensitive toggle switch
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Checkbox(
                              value: term.caseSensitive,
                              onChanged: (value) {
                                final updatedTerm = term.copyWith(caseSensitive: value ?? false);
                                final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                glossaryService.updateAISuggestion(updatedTerm);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                        
                        // Add more space between toggles and examples
                        const SizedBox(width: 16),
                        
                        // Examples column
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select an example to include:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...List.generate(term.examples.length.clamp(0, 3), (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Radio<int>(
                                              value: index,
                                              groupValue: selectedExamples[term.id]?.first,
                                              onChanged: (value) {
                                                onExampleToggle(term.id, value ?? 0, true);
                                              },
                                              visualDensity: VisualDensity.compact,
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            Expanded(
                                              child: Text(
                                                term.examples[index],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: colorScheme.onSurface,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 30.0),
                                          child: Text(
                                            'Found on: ${term.exampleSources?[index] ?? 'unknown location'}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        
                        // Actions column (with Accept and Reject buttons)
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Add button - matches glossary style
                              IconButton(
                                icon: const Icon(Icons.check_rounded),
                                onPressed: () {
                                  // Check if the example is selected
                                  final isExampleSelected = selectedExamples.containsKey(term.id) && 
                                                          selectedExamples[term.id]!.contains(0);
                                  
                                  // Create a new term with or without the example
                                  final termToAdd = term.copyWith(
                                    examples: isExampleSelected && term.examples.isNotEmpty
                                        ? [term.examples[0]] // Add only the first example if selected
                                        : [] // Otherwise add empty list
                                  );
                                  
                                  // Add term to glossary
                                  final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                  glossaryService.acceptAISuggestion(termToAdd);
                                  
                                  // Call the callback to notify the parent screen
                                  onTermAccepted();
                                },
                                tooltip: 'Add to glossary',
                                iconSize: 20,
                                color: Colors.green,
                              ),
                              
                              // Reject button - matches glossary style
                              IconButton(
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () {
                                  // Reject the term suggestion
                                  final glossaryService = Provider.of<GlossaryService>(context, listen: false);
                                  glossaryService.rejectAISuggestion(term);
                                },
                                tooltip: 'Reject term',
                                iconSize: 20,
                                color: Colors.red,
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
  return Padding(
    padding: const EdgeInsets.all(16.0), // Consistent 16px padding on all sides
    child: Container(
      width: double.infinity, // Take full width of parent
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'There are no more term candidates to review',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  'Run again if you\'ve added new content to your website. Already added terms won\'t show up in this list.',
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );
} 