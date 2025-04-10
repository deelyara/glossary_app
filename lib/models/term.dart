class Term {
  final String text;
  final double usageScore;
  final List<String> examples;
  final List<String> exampleSources;
  bool doNotTranslate;
  bool caseSensitive;
  final String? translation;

  Term({
    required this.text,
    required this.usageScore,
    required this.examples,
    required this.exampleSources,
    this.doNotTranslate = false,
    this.caseSensitive = false,
    this.translation,
  });

  Term copyWith({
    String? text,
    double? usageScore,
    List<String>? examples,
    List<String>? exampleSources,
    bool? doNotTranslate,
    bool? caseSensitive,
    String? translation,
  }) {
    return Term(
      text: text ?? this.text,
      usageScore: usageScore ?? this.usageScore,
      examples: examples ?? this.examples,
      exampleSources: exampleSources ?? this.exampleSources,
      doNotTranslate: doNotTranslate ?? this.doNotTranslate,
      caseSensitive: caseSensitive ?? this.caseSensitive,
      translation: translation ?? this.translation,
    );
  }
}