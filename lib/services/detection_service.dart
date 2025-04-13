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

  DetectionStatus get status => _status;
  List<Term> get detectedTerms => _detectedTerms;
  String get errorMessage => _errorMessage;
  int get termCount => _termCount;

  // Simulate AI detection process
  Future<void> detectTerms() async {
    _status = DetectionStatus.inProgress;
    _errorMessage = '';
    notifyListeners();
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 3));
      
      // Mock detected terms
      _detectedTerms = [
        Term(
          id: 'term_1',
          text: 'Configuration',
          usageScore: 25,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
          id: 'term_2',
          text: 'API',
          usageScore: 25,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: true,
          caseSensitive: true,
        ),
        Term(
          id: 'term_3',
          text: 'Component',
          usageScore: 25,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
      ];
      
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
    notifyListeners();
  }
  
  // Simulate starting a new detection with more terms
  Future<void> detectMoreTerms() async {
    _status = DetectionStatus.inProgress;
    notifyListeners();
    
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Additional mock terms
      _detectedTerms = [
        Term(
          id: 'term_4',
          text: 'Framework',
          usageScore: 35,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
          id: 'term_5',
          text: 'Repository',
          usageScore: 20,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: true,
        ),
        Term(
          id: 'term_6',
          text: 'Dependency',
          usageScore: 15,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
          id: 'term_7',
          text: 'Interface',
          usageScore: 28,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
      ];
      
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