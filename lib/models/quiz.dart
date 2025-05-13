class Quiz {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  Quiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });
}
