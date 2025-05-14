import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_result.dart';

Future<void> saveQuizResult(QuizResult result) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getStringList('quiz_results') ?? [];
  data.add(jsonEncode(result.toJson()));
  await prefs.setStringList('quiz_results', data);
}

// ✅ 전체 결과 불러오기
Future<List<QuizResult>> getAllResults() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getStringList('quiz_results') ?? [];
  return data.map((e) => QuizResult.fromJson(jsonDecode(e))).toList();
}