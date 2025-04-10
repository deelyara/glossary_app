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
    }
    
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