
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/quiz_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SampleQuizScreen extends StatefulWidget {
  const SampleQuizScreen({super.key});

  @override
  State<SampleQuizScreen> createState() => _SampleQuizScreenState();
}

class _SampleQuizScreenState extends State<SampleQuizScreen> {
  List<Map<String, dynamic>> sampleQuizzes = [];
  int currentIndex = 0;
  bool answered = false;
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    loadSampleData();
  }

  Future<void> loadSampleData() async {
    final url = 'https://sondongwook.github.io/daily_one_minute_app/daily_quiz.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final values = jsonMap.entries.map((e) {
        final map = Map<String, dynamic>.from(e.value);
        map['keyDate'] = e.key;
        return map;
      }).toList();
      setState(() {
        sampleQuizzes = values;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("퀴즈 데이터를 불러오지 못했습니다.")),
      );
    }
  }

  Future<void> saveResult(bool isCorrect, Map<String, dynamic> quiz, String selected) async {
    final prefs = await SharedPreferences.getInstance();
    final result = QuizResult(
      date: DateTime.now(),
      question: quiz['question'],
      options: List<String>.from(quiz['options']),
      selectedAnswer: selected,
      correctAnswer: quiz['answer'],
      isCorrect: isCorrect,
      duration: Duration(seconds: 10),
    );
    final data = prefs.getStringList('quiz_results') ?? [];
    data.add(jsonEncode(result.toJson()));
    await prefs.setStringList('quiz_results', data);
  }

  void handleAnswer(String answer) async {
    if (answered) return;
    final current = sampleQuizzes[currentIndex];
    final isCorrect = answer == current['answer'];

    setState(() {
      selectedAnswer = answer;
      answered = true;
    });

    await saveResult(isCorrect, current, answer);

    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("다음 문제로 진행할까요?"),
          content: const Text("계속해서 샘플 문제를 풀 수 있습니다."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.popUntil(context, (route) => route.isFirst); // back to home
              },
              child: const Text("그만 풀기"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                if (currentIndex < sampleQuizzes.length - 1) {
                  setState(() {
                    currentIndex++;
                    answered = false;
                    selectedAnswer = null;
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("완료"),
                      content: const Text("모든 샘플 문제를 풀었습니다."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                          child: const Text("홈으로"),
                        )
                      ],
                    ),
                  );
                }
              },
              child: const Text("다음 문제"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (sampleQuizzes.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final quiz = sampleQuizzes[currentIndex];
    final options = List<String>.from(quiz['options']);
    final dateStr = quiz['keyDate'];

    return Scaffold(
      appBar: AppBar(title: const Text("샘플 문제 풀기")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q${currentIndex + 1}. ${quiz['question']}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("📅 날짜: $dateStr", style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 24),
            ...options.map((option) {
              final isSelected = selectedAnswer == option;
              final isCorrect = option == quiz['answer'];
              Color? color;
              if (answered) {
                if (isSelected && isCorrect) color = Colors.green;
                else if (isSelected && !isCorrect) color = Colors.red;
                else if (!isSelected && isCorrect) color = Colors.green.withOpacity(0.4);
                else color = Colors.grey[300];
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => handleAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(option, style: const TextStyle(fontSize: 18)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
