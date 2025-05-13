import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  final int daysToShow = 7;
  Map<String, String?> dailyResults = {};

  @override
  void initState() {
    super.initState();
    loadQuizHistory();
  }

  Future<void> loadQuizHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    Map<String, String?> result = {};

    for (int i = 0; i < daysToShow; i++) {
      final date = now.subtract(Duration(days: i));
      final key = 'quizResult_${DateFormat('yyyyMMdd').format(date)}';
      final value = prefs.getString(key);  // ✅ 값이 없으면 null
      final label = DateFormat('M/d (E)', 'ko_KR').format(date);

      result[label] = value ?? 'none'; // ✅ 기본값 추가
      print('[$label] → 저장된 결과: $value');
    }

    setState(() {
      dailyResults = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('최근 퀴즈 기록')),
      body: ListView(
        children: dailyResults.entries.map((entry) {
          final date = entry.key;
          final result = entry.value;
          String status;

          if (result == 'correct') {
            status = '✅ 정답';
          } else if (result == 'wrong') {
            status = '❌ 오답';
          } else {
            status = '❓ 미응시';
          }

          return ListTile(
            tileColor: Colors.yellow[100], // ← 확인용 색상
            title: Text(date),
            trailing: Text(status),
          );
        }).toList(),
      ),
    );
  }
}
