import 'term.dart';

class Glossary {
  final String name;
  final String targetLanguage;
  final List<Term> terms;

  Glossary({
    required this.name,
    required this.targetLanguage,
    required this.terms,
  });

  Glossary copyWith({
    String? name,
    String? targetLanguage,
    List<Term>? terms,
  }) {
    return Glossary(
      name: name ?? this.name,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      terms: terms ?? this.terms,
    );
  }

  Glossary addTerm(Term term) {
    final updatedTerms = List<Term>.from(terms);
    updatedTerms.add(term);
    return copyWith(terms: updatedTerms);
  }

  Glossary removeTerm(Term term) {
    final updatedTerms = List<Term>.from(terms);
    updatedTerms.removeWhere((t) => t.text == term.text);
    return copyWith(terms: updatedTerms);
  }
}