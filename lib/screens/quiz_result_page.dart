
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/quiz_session_result.dart';
import '../models/quiz_result.dart';

class QuizResultPage extends StatelessWidget {
  final QuizSessionResult sessionResult;

  const QuizResultPage({super.key, required this.sessionResult});

  @override
  Widget build(BuildContext context) {
    final percent = sessionResult.correctCount / sessionResult.totalQuestions;
    final formattedDate = DateFormat.yMMMMd('ko').format(sessionResult.date);
    final durationStr = sessionResult.duration.inSeconds < 60
      ? "${sessionResult.duration.inSeconds}초"
      : "${sessionResult.duration.inMinutes}분 ${sessionResult.duration.inSeconds % 60}초";

    return Scaffold(
      appBar: AppBar(
        title: const Text('퀴즈 결과'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 10.0,
              percent: percent,
              center: Text("${(percent * 100).toStringAsFixed(1)}%"),
              progressColor: Colors.green,
              backgroundColor: Colors.grey[300]!,
              animation: true,
              animationDuration: 800,
            ),
            const SizedBox(height: 16),
            Text("${sessionResult.correctCount} / ${sessionResult.totalQuestions}개 정답",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text("주제: ${sessionResult.topic}"),
            Text("날짜: $formattedDate"),
            Text("소요 시간: ${sessionResult.duration.inSeconds}초"),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: sessionResult.results.length,
                itemBuilder: (context, index) {
                  final result = sessionResult.results[index];
                  return ListTile(
                    title: Text(result.question),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("선택한 답변: ${result.selectedAnswer}"),
                        Text("정답: ${result.correctAnswer}"),
                      ],
                    ),
                    trailing: Icon(
                      result.isCorrect ? Icons.check_circle : Icons.cancel,
                      color: result.isCorrect ? Colors.green : Colors.red,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
