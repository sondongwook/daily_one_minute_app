import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz.dart';
import '../models/quiz_result.dart';
import '../services/quiz_storage.dart';
import '../screens/quiz_result_page.dart';
import '../models/quiz_session_result.dart'; // 추가


class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Quiz? quiz;
  String? selectedOption;
  bool hasAnswered = false;
  late final Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch()..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    quiz = ModalRoute.of(context)?.settings.arguments as Quiz?;
  }

  void _onOptionSelected(String option) async {
    if (hasAnswered || quiz == null) return;

    setState(() {
      selectedOption = option;
      hasAnswered = true;
    });

    final result = QuizResult(
      date: DateTime.now(),
      question: quiz!.question,
      options: quiz!.options,
      selectedAnswer: option,
      correctAnswer: quiz!.answer,
      isCorrect: option == quiz!.answer,
    );

    await saveQuizResult(result);
    
    // ✅ 퀴즈 날짜 저장
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await prefs.setString('lastQuizDate', todayStr);

    Future.delayed(const Duration(milliseconds: 600), () {
      final sessionResult = QuizSessionResult(
        date: DateTime.now(),
        topic: '오늘의 퀴즈', // 또는 quiz!.category 등이 있다면 그걸로
        correctCount: option == quiz!.answer ? 1 : 0,
        totalQuestions: 1,
        //duration: const Duration(seconds: 10), // 추후 stopwatch로 시간 측정 가능
        duration: stopwatch.elapsed, // ✅ 실제 경과 시간
        results: [result],
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultPage(sessionResult: sessionResult),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (quiz == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('오늘의 퀴즈')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz!.question,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...quiz!.options.map((option) {
              final isCorrect = option == quiz!.answer;
              final isSelected = option == selectedOption;

              Color? color;
              if (hasAnswered) {
                if (isSelected && isCorrect) {
                  color = Colors.green;
                } else if (isSelected && !isCorrect) {
                  color = Colors.red;
                } else if (!isSelected && isCorrect) {
                  color = Colors.green.withOpacity(0.4);
                } else {
                  color = Colors.grey.shade300;
                }
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _onOptionSelected(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(option, style: const TextStyle(fontSize: 18)),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
