// lib/widgets/terms/term_table.dart
import 'package:flutter/material.dart';
import '../../models/term.dart';
import '../../config/theme.dart';

class TermTable extends StatelessWidget {
  final List<Term> terms;
  final Function(Term, bool) onDoNotTranslateToggle;
  final Function(Term, bool) onCaseSensitiveToggle;
  final Function(Term) onAddTerm;
  final Function(Term) onRejectTerm;

  const TermTable({
    super.key,
    required this.terms,
    required this.onDoNotTranslateToggle,
    required this.onCaseSensitiveToggle,
    required this.onAddTerm,
    required this.onRejectTerm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Checkbox(
                  value: false,
                  onChanged: (value) {
                    // This would select/deselect all
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Term',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Usage score',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Examples',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Do not translate',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Case sensitive',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Actions',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Table rows
        if (terms.isNotEmpty)
          ...terms.map((term) => _buildTermRow(context, term)),
        
        // Empty state
        if (terms.isEmpty)
          Container(
            padding: const EdgeInsets.all(36),
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
            child: Column(
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
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Run again if you\'ve added new content to your website.',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Detect terms'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
        // Bottom border when we have items
        if (terms.isNotEmpty)
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
      ],
    );
  }

  Widget _buildTermRow(BuildContext context, Term term) {
    final bool isEven = terms.indexOf(term) % 2 == 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: isEven ? Colors.white : const Color(0xFFFAFAFA),
        border: Border(
          left: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            height: 24,
            child: Checkbox(
              value: false, // This would be tied to selection state
              onChanged: (value) {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                term.text,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getScoreColor(term.usageScore),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      term.usageScore.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: term.examples.map((example) {
                final index = term.examples.indexOf(example);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: true, // This would be tied to selection state
                            onChanged: (value) {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              example,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Text(
                        'Found on: ${term.exampleSources[index]}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textTertiaryColor,
                        ),
                      ),
                    ),
                    if (index < term.examples.length - 1) const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Switch(
                value: term.doNotTranslate,
                onChanged: (value) => onDoNotTranslateToggle(term, value),
                activeColor: AppTheme.primaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Switch(
                value: term.caseSensitive,
                onChanged: (value) => onCaseSensitiveToggle(term, value),
                activeColor: AppTheme.primaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Improved Reject Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onRejectTerm(term),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Tooltip(
                        message: 'Reject term',
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.close, 
                            color: AppTheme.errorColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Improved Add Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onAddTerm(term),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Tooltip(
                        message: 'Add to glossary',
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.1),
                            border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.add,
                            color: AppTheme.successColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getScoreColor(double score) {
    if (score >= 30) {
      return AppTheme.successColor; // High relevance
    } else if (score >= 20) {
      return AppTheme.primaryColor; // Medium relevance
    } else {
      return AppTheme.warningColor; // Low relevance
    }
  }
}