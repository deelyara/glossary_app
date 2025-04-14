// lib/services/detection_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/term.dart';

enum DetectionStatus {
  idle,
  inProgress,
  completed,
  error,
}

class DetectionService extends ChangeNotifier {
  DetectionStatus _status = DetectionStatus.idle;
  List<Term> _detectedTerms = [];
  String _errorMessage = '';
  int _termCount = 0;
  int _detectionRunCount = 0;
  
  // Keep track of terms that have been rejected or added to the glossary
  final Set<String> _processedTermTexts = <String>{};

  DetectionStatus get status => _status;
  List<Term> get detectedTerms => _detectedTerms;
  String get errorMessage => _errorMessage;
  int get termCount => _termCount;
  int get detectionRunCount => _detectionRunCount;
  
  // Add a term to the processed list (called when term is accepted or rejected)
  void markTermAsProcessed(Term term) {
    _processedTermTexts.add(term.text.toLowerCase());
    notifyListeners();
  }
  
  // Check if a term has been processed before
  bool isTermProcessed(Term term) {
    return _processedTermTexts.contains(term.text.toLowerCase());
  }

  // Simulate AI detection process
  Future<void> detectTerms() async {
    _status = DetectionStatus.inProgress;
    _errorMessage = '';
    _detectionRunCount++;
    notifyListeners();
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 3));
      
      // Mock detected terms for different runs
      List<Term> firstRunTerms = [
        Term(
          id: 'term_1',
          text: 'Configuration',
          usageScore: 25,
          examples: ['Configure the application settings', 'System configuration options', 'Basic configuration guide'],
          exampleSources: ['docs/setup/', 'config/guide/', 'setup/basic/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
          id: 'term_2',
          text: 'API',
          usageScore: 25,
          examples: ['REST API documentation', 'API endpoint details', 'Using the API'],
          exampleSources: ['api/docs/', 'endpoints/', 'guides/api/'],
          doNotTranslate: true,
          caseSensitive: true,
        ),
        Term(
          id: 'term_3',
          text: 'Component',
          usageScore: 25,
          examples: ['Reusable UI components', 'Component lifecycle', 'Custom component creation'],
          exampleSources: ['ui/components/', 'docs/lifecycle/', 'guides/custom/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
      ];

      List<Term> secondRunTerms = [
        Term(
          id: 'term_4',
          text: 'Interface',
          usageScore: 30,
          examples: ['The interface provides a clean way to...', 'Users interact with the interface through...', 'A well-designed interface improves...'],
          exampleSources: ['docs/api/', 'ui/components/', 'design/principles/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
          id: 'term_5',
          text: 'Repository',
          usageScore: 28,
          examples: ['The repository pattern implements...', 'Data is stored in the repository...', 'Accessing the repository requires...'],
          exampleSources: ['src/data/', 'models/repo/', 'services/data/'],
          doNotTranslate: true,
          caseSensitive: true,
        ),
      ];

      List<Term> thirdRunTerms = [
        Term(
          id: 'term_7',
          text: 'Framework',
          usageScore: 35,
          examples: ['The framework provides structure...', 'Building with the framework...', 'Framework best practices...'],
          exampleSources: ['docs/framework/', 'guides/basics/', 'best-practices/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
          id: 'term_8',
          text: 'Algorithm',
          usageScore: 42,
          examples: ['Efficient sorting algorithms', 'Algorithm complexity analysis', 'Implementing search algorithms'],
          exampleSources: ['algorithms/sort/', 'complexity/analysis/', 'search/impl/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
      ];
      
      // Select terms based on detection run count
      if (_detectionRunCount == 1) {
        _detectedTerms = firstRunTerms;
      } else if (_detectionRunCount == 2) {
        _detectedTerms = secondRunTerms;
      } else {
        _detectedTerms = thirdRunTerms;
      }
      
      // Filter out terms that have already been processed
      _detectedTerms = _detectedTerms.where((term) => 
        !_processedTermTexts.contains(term.text.toLowerCase())
      ).toList();
      
      _termCount = _detectedTerms.length;
      _status = DetectionStatus.completed;
      notifyListeners();
    } catch (e) {
      _status = DetectionStatus.error;
      _errorMessage = 'Failed to detect terms: ${e.toString()}';
      notifyListeners();
    }
  }

  void resetDetection() {
    _status = DetectionStatus.idle;
    _detectedTerms = [];
    _errorMessage = '';
    _termCount = 0;
    notifyListeners();
  }
  
  void removeTerm(Term term) {
    _detectedTerms.removeWhere((t) => t.text == term.text);
    _termCount = _detectedTerms.length;
    // Mark the term as processed so it doesn't show up in future runs
    markTermAsProcessed(term);
    notifyListeners();
  }
  
  // Simulate starting a new detection with more terms
  Future<void> detectMoreTerms() async {
    _status = DetectionStatus.inProgress;
    _detectionRunCount++;
    notifyListeners();
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Additional mock terms - filter out any that have been processed
      List<Term> allPossibleTerms = [
        Term(
          id: 'term_4',
          text: 'Framework',
          usageScore: 35,
          examples: ['Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
          id: 'term_5',
          text: 'Repository',
          usageScore: 20,
          examples: ['Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: true,
        ),
        Term(
          id: 'term_6',
          text: 'Dependency',
          usageScore: 15,
          examples: ['Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
          id: 'term_7',
          text: 'Interface',
          usageScore: 28,
          examples: ['Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        // Add more terms to ensure there's always something new to show
        Term(
          id: 'term_8',
          text: 'Algorithm',
          usageScore: 42,
          examples: ['The algorithm processes data efficiently'],
          exampleSources: ['algorithms.html'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
          id: 'term_9',
          text: 'Blockchain',
          usageScore: 38,
          examples: ['Blockchain technology provides security'],
          exampleSources: ['security.html'],
          doNotTranslate: false,
          caseSensitive: true,
        ),
      ];
      
      // Filter out terms that have already been processed
      _detectedTerms = allPossibleTerms.where((term) => 
        !_processedTermTexts.contains(term.text.toLowerCase())
      ).toList();
      
      _termCount = _detectedTerms.length;
      _status = DetectionStatus.completed;
      notifyListeners();
    } catch (e) {
      _status = DetectionStatus.error;
      _errorMessage = 'Failed to detect terms: ${e.toString()}';
      notifyListeners();
    }
  }

  // Mock function to simulate retrieving suggested terms from an API
  Future<List<Term>> detectTermsInText(String text) async {
    // This is a mock - in a real app, this would send the text to an API
    return [
      Term(
        id: 'detect_1',
        text: 'API',
        examples: ['The API documentation is comprehensive.'],
        exampleSources: ['page1.html'],
        usageScore: 85.0,
        doNotTranslate: false,
        caseSensitive: true,
      ),
      Term(
        id: 'detect_2',
        text: 'OAuth',
        examples: ['OAuth authentication is required for this endpoint.'],
        exampleSources: ['page2.html'],
        usageScore: 75.0,
        doNotTranslate: true,
        caseSensitive: true,
      ),
      Term(
        id: 'detect_3',
        text: 'endpoint',
        examples: ['The API endpoint returns JSON data.'],
        exampleSources: ['page3.html'],
        usageScore: 68.0,
        doNotTranslate: false,
        caseSensitive: false,
      ),
    ];
  }

  // Mock function to simulate retrieving already detected terms for a document
  Future<List<Term>> getDetectedTermsForDocument(String documentId) async {
    // In a real app, this would query a database for previously detected terms
    // Here we're just returning mock data
    return [
      Term(
        id: 'doc_1',
        text: 'API',
        examples: ['The API documentation is comprehensive.'],
        exampleSources: ['page1.html'],
        usageScore: 85.0,
        doNotTranslate: false,
        caseSensitive: true,
      ),
      Term(
        id: 'doc_2',
        text: 'OAuth',
        examples: ['OAuth authentication is required for this endpoint.'],
        exampleSources: ['page2.html'],
        usageScore: 75.0,
        doNotTranslate: true,
        caseSensitive: true,
      ),
      Term(
        id: 'doc_3',
        text: 'endpoint',
        examples: ['The API endpoint returns JSON data.'],
        exampleSources: ['page3.html'],
        usageScore: 68.0,
        doNotTranslate: false,
        caseSensitive: false,
      ),
      Term(
        id: 'doc_4',
        text: 'database',
        examples: ['The database connection is secure.'],
        exampleSources: ['page4.html'],
        usageScore: 92.0,
        doNotTranslate: false,
        caseSensitive: false,
      ),
    ];
  }
}