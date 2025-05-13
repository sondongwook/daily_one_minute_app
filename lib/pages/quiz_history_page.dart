import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quiz_result.dart';
import 'package:intl/intl.dart';

class QuizHistoryPage extends StatefulWidget {
  @override
  State<QuizHistoryPage> createState() => _QuizHistoryPageState();
}

class _QuizHistoryPageState extends State<QuizHistoryPage> {
  List<QuizResult> results = [];

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('quiz_results') ?? [];
    final parsed = data.map((e) => QuizResult.fromJson(jsonDecode(e))).toList();
    setState(() {
      results = parsed.reversed.toList(); // 최근 것이 위로
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('퀴즈 기록')),
      body: results.isEmpty
          ? Center(child: Text('아직 기록이 없어요.'))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final r = results[index];
                return ListTile(
                  title: Text(r.question),
                  subtitle: Text("선택: ${r.selectedAnswer} / 정답: ${r.correctAnswer}"),
                  trailing: Icon(
                    r.isCorrect ? Icons.check : Icons.close,
                    color: r.isCorrect ? Colors.green : Colors.red,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("퀴즈 상세"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("문제: ${r.question}"),
                            Text("보기: ${r.options.join(', ')}"),
                            Text("선택: ${r.selectedAnswer}"),
                            Text("정답: ${r.correctAnswer}"),
                            Text("결과: ${r.isCorrect ? '정답' : '오답'}"),
                            Text("날짜: ${DateFormat('yyyy-MM-dd').format(r.date)}"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
