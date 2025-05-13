import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../data/sample_quiz.dart';
import '../models/quiz.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int? selectedIndex;
  bool isAnswered = false;

  Quiz get currentQuiz => sampleQuiz[currentIndex];

  void selectOption(int index) {
    if (isAnswered) return;

    setState(() {
      selectedIndex = index;
      isAnswered = true;
    });
  }

  void goToNext() async {
    if (currentIndex < sampleQuiz.length - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = null;
        isAnswered = false;
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      final today = DateFormat('yyyyMMdd').format(DateTime.now());
      await prefs.setString('lastQuizDate', today); // ✅ 저장

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오늘의 퀴즈')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q. ${currentQuiz.question}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ...List.generate(currentQuiz.options.length, (index) {
              final isCorrect = index == currentQuiz.correctIndex;
              final isSelected = index == selectedIndex;

              Color optionColor() {
                if (!isAnswered) return Colors.grey[200]!;
                if (isCorrect) return Colors.green;
                if (isSelected && !isCorrect) return Colors.red;
                return Colors.grey[200]!;
              }

              return GestureDetector(
                onTap: () => selectOption(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: optionColor(),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Text(currentQuiz.options[index]),
                ),
              );
            }),
            const SizedBox(height: 20),
            if (isAnswered && currentQuiz.explanation != null)
              Text(
                '해설: ${currentQuiz.explanation}',
                style: const TextStyle(color: Colors.black54),
              ),
            const Spacer(),
            if (isAnswered)
              ElevatedButton(
                onPressed: goToNext,
                child: Text(
                  currentIndex < sampleQuiz.length - 1 ? '다음 문제' : '홈으로 돌아가기',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<bool> canPlayTodayQuiz() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateFormat('yyyyMMdd').format(DateTime.now());
  final lastDate = prefs.getString('lastQuizDate');

  return lastDate != today; // 오늘 푼 적 없으면 true
}