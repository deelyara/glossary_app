// lib/services/glossary_service.dart
import 'package:flutter/material.dart';
import '../models/glossary.dart';
import '../models/term.dart';

class GlossaryService extends ChangeNotifier {
  Glossary _currentGlossary = Glossary(
    name: "Project's glossary",
    targetLanguage: "HU-Hungary",
    terms: [],
  );
  
  // List of AI-suggested terms that haven't been added to the glossary yet
  List<Term> _aiSuggestedTerms = [
    Term(
      text: 'CICA',
      usageScore: 78,
      examples: ['This is an example sentence with CICA mentioned.'],
      exampleSources: ['page1.html'],
      doNotTranslate: false,
      caseSensitive: false,
    ),
    Term(
      text: 'tseT rehtonA',
      usageScore: 65,
      examples: ['Here we can see tseT rehtonA in action.'],
      exampleSources: ['page2.html'],
      doNotTranslate: false,
      caseSensitive: true,
    ),
    Term(
      text: 'Test',
      usageScore: 92,
      examples: ['This is a test sentence.'],
      exampleSources: ['page3.html'],
      doNotTranslate: false,
      caseSensitive: false,
    ),
    Term(
      text: 'Krityu',
      usageScore: 58,
      examples: ['Krityu is an important term.'],
      exampleSources: ['page4.html'],
      doNotTranslate: false,
      caseSensitive: false,
    ),
    Term(
      text: 'foobar',
      usageScore: 45,
      examples: ['Developers often use foobar as placeholder.'],
      exampleSources: ['page5.html'],
      doNotTranslate: true,
      caseSensitive: false,
    ),
    Term(
      text: 'kutya',
      usageScore: 81,
      examples: ['The kutya is mentioned in this example.'],
      exampleSources: ['page6.html'],
      doNotTranslate: true,
      caseSensitive: false,
    ),
  ];

  // List of accepted AI terms (moved from AI suggestions to glossary)
  List<Term> _acceptedAITerms = [
    Term(
      text: 'Configuration',
      usageScore: 85,
      examples: ['The configuration process requires admin rights.'],
      exampleSources: ['settings.html'],
      doNotTranslate: false,
      caseSensitive: false,
      translation: 'Konfiguracija',
    ),
    Term(
      text: 'API',
      usageScore: 95,
      examples: ['The API allows third-party integrations.'],
      exampleSources: ['api.html'],
      doNotTranslate: true,
      caseSensitive: true,
    ),
  ];

  // Terms that are already in the glossary
  List<Term> get glossaryTerms => _currentGlossary.terms;
  
  // AI-suggested terms (not yet in the glossary)
  List<Term> get aiSuggestedTerms => _aiSuggestedTerms;
  
  // AI terms that have been accepted
  List<Term> get acceptedAITerms => _acceptedAITerms;
  
  // All terms (glossary terms + accepted AI terms)
  List<Term> get allTerms {
    return [...glossaryTerms, ...acceptedAITerms];
  }
  
  Glossary get currentGlossary => _currentGlossary;

  void updateGlossary(Glossary glossary) {
    _currentGlossary = glossary;
    notifyListeners();
  }

  void addTerm(Term term) {
    // Check if term already exists
    final existingTermIndex = _currentGlossary.terms.indexWhere((t) => t.text == term.text);
    
    if (existingTermIndex >= 0) {
      // Update existing term
      final updatedTerms = List<Term>.from(_currentGlossary.terms);
      updatedTerms[existingTermIndex] = term;
      _currentGlossary = _currentGlossary.copyWith(terms: updatedTerms);
    } else {
      // Add new term
      _currentGlossary = _currentGlossary.addTerm(term);
      
      // If the term was in the AI suggestions, remove it from there
      _removeFromAISuggestions(term);
    }
    
    notifyListeners();
  }
  
  // Add a term from AI suggestions to the glossary
  void acceptAISuggestion(Term term) {
    // Add the term to accepted AI terms
    _acceptedAITerms.add(term);
    
    // Remove from AI suggestions
    _removeFromAISuggestions(term);
    
    notifyListeners();
  }
  
  // Reject an AI suggestion
  void rejectAISuggestion(Term term) {
    // Just remove it from AI suggestions
    _removeFromAISuggestions(term);
    
    notifyListeners();
  }
  
  // Helper to remove a term from AI suggestions
  void _removeFromAISuggestions(Term term) {
    _aiSuggestedTerms.removeWhere((t) => t.text == term.text);
  }
  
  // Add new AI suggested terms to the list
  void addAISuggestedTerms(List<Term> terms) {
    // Filter out terms that are already in the glossary
    final newTerms = terms.where(
      (term) => !_currentGlossary.terms.any((t) => t.text == term.text)
    ).toList();
    
    _aiSuggestedTerms.addAll(newTerms);
    notifyListeners();
  }
  
  // Clear all AI suggested terms
  void clearAISuggestedTerms() {
    _aiSuggestedTerms.clear();
    notifyListeners();
  }

  void removeTerm(Term term) {
    _currentGlossary = _currentGlossary.removeTerm(term);
    notifyListeners();
  }
  
  void updateTermProperty(Term term, {bool? doNotTranslate, bool? caseSensitive, String? translation}) {
    final index = _currentGlossary.terms.indexWhere((t) => t.text == term.text);
    if (index >= 0) {
      final updatedTerm = _currentGlossary.terms[index].copyWith(
        doNotTranslate: doNotTranslate,
        caseSensitive: caseSensitive,
        translation: translation,
      );
      
      final updatedTerms = List<Term>.from(_currentGlossary.terms);
      updatedTerms[index] = updatedTerm;
      _currentGlossary = _currentGlossary.copyWith(terms: updatedTerms);
      notifyListeners();
    }
  }

  Future<void> exportGlossary() async {
    // Implementation for exporting glossary
    // This would involve file handling or API calls
    await Future.delayed(const Duration(seconds: 1));
    // Success notification would be handled by UI
  }

  Future<void> importGlossary() async {
    // Implementation for importing glossary
    // This would involve file handling or API calls
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate importing some terms
    final importedTerms = [
      Term(
        text: 'Imported Term 1',
        usageScore: 40,
        examples: ['Example 1', 'Example 2'],
        exampleSources: ['source1', 'source2'],
        doNotTranslate: false,
        caseSensitive: true,
      ),
      Term(
        text: 'Imported Term 2',
        usageScore: 35,
        examples: ['Example 1', 'Example 2'],
        exampleSources: ['source1', 'source2'],
        doNotTranslate: true,
        caseSensitive: false,
      ),
    ];
    
    for (final term in importedTerms) {
      addTerm(term);
    }
  }
  
  void changeTargetLanguage(String language) {
    _currentGlossary = _currentGlossary.copyWith(targetLanguage: language);
    notifyListeners();
  }
}