import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../data/sample_trivia.dart';
import '../models/trivia.dart';


class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? todayTrivia;

  @override
  void initState() {
    super.initState();
    loadTrivia();
  }

    Future<void> loadTrivia() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final savedDate = prefs.getString('lastShownDate');
    final savedTrivia = prefs.getString('lastTrivia');

    String triviaText;

    if (savedDate == today && savedTrivia != null) {
        triviaText = savedTrivia;
    } else {
        final trivia = sampleTriviaList.firstWhere(
        (t) => t.date == today,
        orElse: () => Trivia(date: today, content: '오늘의 Trivia가 아직 준비되지 않았어요.'),
        );
        triviaText = trivia.content;

        await prefs.setString('lastShownDate', today);
        await prefs.setString('lastTrivia', trivia.content);
    }

    // ✅ 히스토리 저장은 항상 수행 (중복 저장 방지는 선택)
    List<String> history = prefs.getStringList('triviaHistory') ?? [];

    final newEntry = '$today|$triviaText';
    if (!history.contains(newEntry)) {
        history.add(newEntry);
        await prefs.setStringList('triviaHistory', history);
    }

    setState(() {
        todayTrivia = triviaText;
    });
    }

    @override
    Widget build(BuildContext context) {
    return Center(
        child: Text(
        todayTrivia ?? '로딩 중...',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
        ),
    );
    }
}
