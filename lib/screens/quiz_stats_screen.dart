import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizStatsScreen extends StatefulWidget {
  const QuizStatsScreen({super.key});

  @override
  State<QuizStatsScreen> createState() => _QuizStatsScreenState();
}

class _QuizStatsScreenState extends State<QuizStatsScreen> {
  int totalAttempts = 0;
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalAttempts = prefs.getInt('totalAttempts') ?? 0;
      correctAnswers = prefs.getInt('correctAnswers') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = totalAttempts == 0
        ? 0
        : (correctAnswers / totalAttempts * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(title: const Text('퀴즈 통계')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('총 푼 문제 수: $totalAttempts'),
            Text('맞힌 문제 수: $correctAnswers'),
            Text('정답률: $accuracy %'),
            const SizedBox(height: 20),
          
            //🧪 통계 초기화 버튼 (디버깅 시 사용)
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('totalAttempts');
                await prefs.remove('correctAnswers');
                await loadStats(); // 다시 불러오기
              },
              child: const Text('통계 초기화'),
            ),
            
          ],
        ),
      ),
    );
  }
}
