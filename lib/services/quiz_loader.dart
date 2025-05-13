import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';

class QuizLoader {
  static Future<Quiz?> loadTodayQuiz() async {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    const jsonUrl = 'https://sondongwook.github.io/daily_one_minute_app/daily_quiz.json';

    try {
      final response = await http.get(Uri.parse(jsonUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey(todayStr)) {
          return Quiz.fromJson(data[todayStr]);
        }
      }
    } catch (e) {
      print('퀴즈 불러오기 실패: $e');
    }
    return null;
  }
}
