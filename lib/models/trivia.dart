class Trivia {
  final String date;
  final String content;

  Trivia({required this.date, required this.content});

  factory Trivia.fromJson(Map<String, dynamic> json) {
    return Trivia(
      date: json['date'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'content': content,
      };
}
