class Trivia {
  final String date;
  final String question;
  final List<String> options;
  final String answer;

  Trivia({
    required this.date,
    required this.question,
    required this.options,
    required this.answer,
  });

  factory Trivia.fromJson(Map<String, dynamic> json) {
    return Trivia(
      date: json['date'],
      question: json['question'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'question': question,
        'options': options,
        'answer': answer,
      };
}
