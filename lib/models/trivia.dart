class Trivia {
  final String date;
  final String title;
  final String description;

  Trivia({
    required this.date,
    required this.title,
    required this.description,
  });

  factory Trivia.fromJson(Map<String, dynamic> json) {
    return Trivia(
      date: json['date'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'title': title,
        'description': description,
      };
}
