import 'quiz_result.dart';

class QuizSessionResult {
  final DateTime date;
  final String topic;
  final int correctCount;
  final int totalQuestions;
  final Duration duration;
  final List<QuizResult> results;

  QuizSessionResult({
    required this.date,
    required this.topic,
    required this.correctCount,
    required this.totalQuestions,
    required this.duration,
    required this.results,
  });
}
