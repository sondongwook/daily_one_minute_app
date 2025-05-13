import 'package:flutter/material.dart';
import '../models/quiz.dart';

class QuizResultPage extends StatelessWidget {
  final Quiz? quiz;
  final String selectedOption;

  const QuizResultPage({
    super.key,
    required this.quiz,
    required this.selectedOption,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = quiz != null && selectedOption == quiz!.answer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('퀴즈 결과'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz?.question ?? '질문 없음',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text('당신의 선택: $selectedOption', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('정답: ${quiz?.answer ?? '알 수 없음'}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text(
              isCorrect ? '🎉 정답입니다!' : '❌ 오답입니다.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('홈으로 돌아가기'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
