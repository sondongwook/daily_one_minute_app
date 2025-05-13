import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;

  const QuizResultScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final scorePercent = (correctAnswers / totalQuestions * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(title: const Text('퀴즈 결과')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎉 퀴즈 완료!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            Text('총 문제 수: $totalQuestions'),
            Text('맞힌 문제 수: $correctAnswers'),
            Text('정답률: $scorePercent%'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
