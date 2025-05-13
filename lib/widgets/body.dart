import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart'; // ✅ 공유 기능 추가
import 'package:google_fonts/google_fonts.dart'; // ✅ 폰트 기능 추가
// import 'package:shared_preferences/shared_preferences.dart';
// import '../data/sample_trivia.dart';
import '../services/trivia_loader.dart'; // ✅ TriviaLoader로 대체
import '../models/trivia.dart';
import '../screens/quiz_screen.dart';


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
    final trivia = await TriviaLoader.loadTodayTrivia();
    final triviaText = trivia?.content ?? '오늘의 Trivia가 아직 준비되지 않았어요.';

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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizScreen()),
              );
            },
            child: const Text('오늘의 퀴즈 풀기'),
          ),
        ],
      ),
    );
  }
}
