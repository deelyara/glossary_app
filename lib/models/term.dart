class Term {
  final String id;
  final String text;
  String? translation;
  List<String> examples;
  List<String>? exampleSources;
  bool doNotTranslate;
  bool caseSensitive;
  bool confirmed;
  double usageScore;

  Term({
    required this.id,
    required this.text,
    this.translation,
    this.examples = const [],
    this.exampleSources,
    this.doNotTranslate = false,
    this.caseSensitive = false,
    this.confirmed = false,
    this.usageScore = 0.0,
  });

  Term copyWith({
    String? id,
    String? text,
    String? translation,
    List<String>? examples,
    List<String>? exampleSources,
    bool? doNotTranslate,
    bool? caseSensitive,
    bool? confirmed,
    double? usageScore,
  }) {
    return Term(
      id: id ?? this.id,
      text: text ?? this.text,
      translation: translation ?? this.translation,
      examples: examples ?? List.from(this.examples),
      exampleSources: exampleSources ?? this.exampleSources,
      doNotTranslate: doNotTranslate ?? this.doNotTranslate,
      caseSensitive: caseSensitive ?? this.caseSensitive,
      confirmed: confirmed ?? this.confirmed,
      usageScore: usageScore ?? this.usageScore,
    );
  }
}