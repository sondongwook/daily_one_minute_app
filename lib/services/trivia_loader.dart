import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trivia.dart';

class TriviaLoader {
  static Future<Trivia?> loadTodayTrivia() async {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    const url = 'https://sondongwook.github.io/daily_one_minute_app/daily_trivia.json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        final trivia = list.firstWhere((item) => item['date'] == todayStr, orElse: () => null);
        if (trivia != null) return Trivia.fromJson(trivia);
      }
    } catch (e) {
      print('Trivia 로딩 실패: $e');
    }
    return null;
  }
}
