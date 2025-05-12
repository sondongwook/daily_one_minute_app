// lib/services/trivia_loader.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trivia.dart';

class TriviaLoader {
  static Future<Trivia?> loadTodayTrivia() async {
    final today = DateTime.now();
    final todayStr = '${today.year}-${_pad(today.month)}-${_pad(today.day)}';

    final url = Uri.parse('https://sondongwook.github.io/daily_one_minute_app/daily_trivia.json'); // 여기에 실제 주소 입력
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final todayData = data.firstWhere(
        (item) => item['date'] == todayStr,
        orElse: () => null,
      );

      if (todayData != null) {
        return Trivia(
          id: todayStr,
          title: todayData['title'],
          description: todayData['description'],
        );
      }
    }

    return null;
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}
