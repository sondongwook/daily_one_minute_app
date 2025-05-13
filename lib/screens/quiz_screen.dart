import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/sample_quiz.dart';
import '../models/quiz.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int? selectedIndex;
  bool isAnswered = false;
  int _correctCount = 0;

  Quiz get currentQuiz => sampleQuiz[currentIndex];

  void selectOption(int index) {
    if (isAnswered) return;

    final isCorrect = index == currentQuiz.correctIndex;

    if (isCorrect) {
      _correctCount++; // ✅ 정답 개수 카운트
    }

    updateQuizStats(isCorrect); // ✅ 통계 업데이트

    setState(() {
      selectedIndex = index;
      isAnswered = true;
    });
  }

  void goToNext() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyyMMdd').format(DateTime.now());

    // 오늘 푼 기록 저장 (하루 1회 제한용)
    await prefs.setString('lastQuizDate', today);

    // ✅ 오늘 푼 문제의 정답 여부 저장
    final todayKey = 'quizResult_$today';
    final isCorrect = selectedIndex != null && selectedIndex == currentQuiz.correctIndex;
    await prefs.setString(todayKey, isCorrect ? 'correct' : 'wrong');

    final total = sampleQuiz.length;
    final correct = _correctCount;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          totalQuestions: total,
          correctAnswers: correct,
        ),
      ),
    );
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

// 오늘만 한 문제
Future<bool> canPlayTodayQuiz() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateFormat('yyyyMMdd').format(DateTime.now());
  final lastDate = prefs.getString('lastQuizDate');

  return lastDate != today; // 오늘 푼 적 없으면 true
}

// 통계 저장 로직 만들기
Future<void> updateQuizStats(bool isCorrect) async {
  final prefs = await SharedPreferences.getInstance();
  final totalAttempts = prefs.getInt('totalAttempts') ?? 0;
  final correctAnswers = prefs.getInt('correctAnswers') ?? 0;

  await prefs.setInt('totalAttempts', totalAttempts + 1);
  if (isCorrect) {
    await prefs.setInt('correctAnswers', correctAnswers + 1);
  }
}