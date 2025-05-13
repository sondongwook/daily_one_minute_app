class QuizResult {
  final DateTime date;
  final String question;
  final List<String> options;
  final String selectedAnswer;
  final String correctAnswer;
  final bool isCorrect;

  QuizResult({
    required this.date,
    required this.question,
    required this.options,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'question': question,
    'options': options,
    'selectedAnswer': selectedAnswer,
    'correctAnswer': correctAnswer,
    'isCorrect': isCorrect,
  };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
    date: DateTime.parse(json['date']),
    question: json['question'],
    options: List<String>.from(json['options']),
    selectedAnswer: json['selectedAnswer'],
    correctAnswer: json['correctAnswer'],
    isCorrect: json['isCorrect'],
  );
}
