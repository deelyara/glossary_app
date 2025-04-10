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
          text: 'Configuration',
          usageScore: 25,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
          text: 'API',
          usageScore: 25,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: true,
          caseSensitive: true,
        ),
        Term(
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
          text: 'Framework',
          usageScore: 35,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
          text: 'Repository',
          usageScore: 20,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: true,
        ),
        Term(
          text: 'Dependency',
          usageScore: 15,
          examples: ['Boci is a very good girl, she always..', 'Boci is a very good girl, she always..'],
          exampleSources: ['dogs/boci/', 'dogs/boci/'],
          doNotTranslate: false,
          caseSensitive: false,
        ),
        Term(
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
}