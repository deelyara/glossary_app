// lib/services/glossary_service.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/glossary.dart';
import '../models/term.dart';
import 'detection_service.dart';

class GlossaryService extends ChangeNotifier {
  Glossary _currentGlossary = Glossary(
    name: "Project's glossary",
    targetLanguage: "HU-Hungary",
    terms: [],
  );
  
  // Sample terms data (in a real app, this would come from an API or database)
  final List<Term> _allTerms = [
    Term(
      id: '1',
      text: 'CICA',
      translation: 'kitijjk',
      examples: ['exgfhjhgh'],
      caseSensitive: false,
      doNotTranslate: false,
      confirmed: true,
    ),
    Term(
      id: '2',
      text: 'tseT rehtonA',
      translation: 'hh,,yuyu',
      examples: ['It works here'],
      caseSensitive: true,
      doNotTranslate: false,
      confirmed: false,
    ),
    Term(
      id: '3',
      text: 'Test',
      translation: 'ddd',
      examples: ['Test sentence'],
      caseSensitive: false,
      doNotTranslate: false,
      confirmed: false,
    ),
    Term(
      id: '4',
      text: 'Krityu',
      translation: 'Krityu',
      examples: ['példakkkj'],
      caseSensitive: false,
      doNotTranslate: false,
      confirmed: false,
    ),
    Term(
      id: '5',
      text: 'foobar',
      translation: null, // This term is not translatable
      examples: ['hyfffghhfghghg'],
      caseSensitive: false,
      doNotTranslate: true,
      confirmed: false,
    ),
    Term(
      id: '6',
      text: 'kutya',
      translation: null, // This term is not translatable
      examples: ['Indul a pap aludni'],
      caseSensitive: false,
      doNotTranslate: true,
      confirmed: true,
    ),
  ];

  // Sample AI suggested terms (in a real app, this would come from an AI service)
  final List<Term> _aiSuggestedTerms = [
    Term(
      id: 'ai1',
      text: 'API',
      translation: null,
      examples: [
        'The API documentation is comprehensive and well-organized.',
        'Developers need to use the REST API to integrate with our service.',
        'The new version of the API includes several performance improvements.'
      ],
      caseSensitive: true,
      doNotTranslate: true,
      confirmed: false,
      usageScore: 98,
    ),
    Term(
      id: 'ai2',
      text: 'UI Component',
      translation: null,
      examples: [
        'The UI component library makes it easy to maintain design consistency.',
        'We need to refactor this UI component to make it more accessible.',
        'The new UI component supports both light and dark themes.'
      ],
      caseSensitive: false,
      doNotTranslate: false,
      confirmed: false,
      usageScore: 75,
    ),
    Term(
      id: 'ai3',
      text: 'Authentication',
      translation: null,
      examples: [
        'Two-factor authentication adds an extra layer of security to your account.',
        'The authentication process needs to be streamlined for better user experience.',
        'We need to implement OAuth authentication for third-party integrations.'
      ],
      caseSensitive: false,
      doNotTranslate: false,
      confirmed: false,
      usageScore: 89,
    ),
    Term(
      id: 'ai4',
      text: 'Database',
      translation: null,
      examples: [
        'The application uses a NoSQL database for better scalability.',
        'We need to optimize our database queries to improve performance.',
        'The database migration will be scheduled during the maintenance window.'
      ],
      caseSensitive: false,
      doNotTranslate: false,
      confirmed: false,
      usageScore: 93,
    ),
  ];

  // List of accepted AI terms (moved from AI suggestions to glossary)
  List<Term> _acceptedAITerms = [
    Term(
      id: 'accepted_1',
      text: 'Configuration',
      usageScore: 85,
      examples: ['The configuration process requires admin rights.'],
      exampleSources: ['settings.html'],
      doNotTranslate: false,
      caseSensitive: false,
      translation: 'Konfiguracija',
    ),
    Term(
      id: 'accepted_2',
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

  // Reference to DetectionService
  DetectionService? _detectionService;

  // Method to set the detection service (will be called from main screen)
  void setDetectionService(DetectionService service) {
    _detectionService = service;
  }

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
    // Add the term to the accepted AI terms list
    _acceptedAITerms.add(term.copyWith(
      // Using timestamp for a more unique ID, consider UUID in production
      id: 'accepted_${DateTime.now().millisecondsSinceEpoch}', 
    ));
    
    // Remove from AI suggestions
    _aiSuggestedTerms.removeWhere((t) => t.id == term.id);
    
    // Mark this term as processed in the detection service
    if (_detectionService != null) {
      _detectionService!.markTermAsProcessed(term);
    }
    
    notifyListeners();
  }
  
  // Reject an AI suggestion
  void rejectAISuggestion(Term term) {
    // Just remove from suggestions
    _aiSuggestedTerms.removeWhere((t) => t.id == term.id);
    
    // Mark this term as processed in the detection service
    if (_detectionService != null) {
      _detectionService!.markTermAsProcessed(term);
    }
    
    notifyListeners();
  }
  
  // Helper to remove a term from AI suggestions
  void _removeFromAISuggestions(Term term) {
    _aiSuggestedTerms.removeWhere((t) => t.text == term.text);
    
    // Mark this term as processed in the detection service
    if (_detectionService != null) {
      _detectionService!.markTermAsProcessed(term);
    }
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
  
  // Sort AI suggestions by usage score
  void sortAISuggestionsByUsageScore(bool ascending) {
    _aiSuggestedTerms.sort((a, b) => ascending
        ? a.usageScore.compareTo(b.usageScore)
        : b.usageScore.compareTo(a.usageScore));
    notifyListeners();
  }
  
  // Toggle Do Not Translate for an AI suggested term
  void toggleDoNotTranslate(Term term) {
    final index = _aiSuggestedTerms.indexWhere((t) => t.id == term.id);
    if (index >= 0) {
      _aiSuggestedTerms[index] = _aiSuggestedTerms[index].copyWith(
        doNotTranslate: !_aiSuggestedTerms[index].doNotTranslate,
      );
      notifyListeners();
    }
  }
  
  // Toggle Case Sensitive for an AI suggested term
  void toggleCaseSensitive(Term term) {
    final index = _aiSuggestedTerms.indexWhere((t) => t.id == term.id);
    if (index >= 0) {
      _aiSuggestedTerms[index] = _aiSuggestedTerms[index].copyWith(
        caseSensitive: !_aiSuggestedTerms[index].caseSensitive,
      );
      notifyListeners();
    }
  }
  
  // Update an AI suggested term
  void updateAISuggestion(Term updatedTerm) {
    final index = _aiSuggestedTerms.indexWhere((t) => t.id == updatedTerm.id);
    if (index >= 0) {
      print('Updating AI suggestion: ${updatedTerm.text}, doNotTranslate: ${updatedTerm.doNotTranslate}, caseSensitive: ${updatedTerm.caseSensitive}');
      _aiSuggestedTerms[index] = updatedTerm;
      notifyListeners();
    } else {
      print('Term not found for update: ${updatedTerm.id}');
    }
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
        id: 'imported_1',
        text: 'Imported Term 1',
        usageScore: 40,
        examples: ['Example 1', 'Example 2'],
        exampleSources: ['source1', 'source2'],
        doNotTranslate: false,
        caseSensitive: true,
      ),
      Term(
        id: 'imported_2',
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

  // Create a new empty project
  void createNewProject() {
    // In a real app, this would create a new project in the backend
    // For now, just reset to empty lists
    _allTerms.clear();
    _aiSuggestedTerms.clear();
    
    // Add example terms for demo
    _allTerms.addAll([
      Term(
        id: 'term_1',
        text: 'CICA',
        translation: 'kitijjk',
        examples: ['exgfhjhgh'],
        caseSensitive: false,
        doNotTranslate: false,
        confirmed: true,
      ),
      Term(
        id: 'term_2',
        text: 'tseT rehtonA',
        translation: 'hh,,yuyu',
        examples: ['It works here'],
        caseSensitive: true,
        doNotTranslate: false,
        confirmed: false,
      ),
    ]);
    
    // Add example AI suggestions
    _aiSuggestedTerms.addAll([
      Term(
        id: 'suggestion_1',
        text: 'UI Component',
        examples: ['The UI component is well-designed'],
        exampleSources: ['page1.html'],
        usageScore: 75,
        doNotTranslate: false,
        caseSensitive: false,
      ),
      Term(
        id: 'suggestion_2',
        text: 'Authentication',
        examples: ['The authentication process is secure'],
        exampleSources: ['page2.html'],
        usageScore: 85,
        doNotTranslate: false,
        caseSensitive: false,
      ),
    ]);
    
    notifyListeners();
  }

  // Remove an accepted AI term (e.g., when deleting)
  void removeAcceptedAITerm(Term term) {
    _acceptedAITerms.removeWhere((t) => t.id == term.id);
    notifyListeners();
  }
}