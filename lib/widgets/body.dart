import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart'; // ✅ 공유 기능 추가
import 'package:google_fonts/google_fonts.dart'; // ✅ 폰트 기능 추가
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
    return AnimatedOpacity(
      opacity: todayTrivia == null ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeIn,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              todayTrivia ?? '',
              textAlign: TextAlign.center,
              style: GoogleFonts.nanumGothic(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: todayTrivia == null
                ? null
                : () {
                    Share.share('오늘의 Trivia 🤓\n\n$todayTrivia\n\n하루 1분 상식 앱에서 가져왔어요!');
                  },
            icon: const Icon(Icons.share),
            label: const Text('공유하기'),
          ),
        ],
      ),
    );
  }
}
