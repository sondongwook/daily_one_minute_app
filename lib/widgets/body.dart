import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/trivia_loader.dart';
import '../models/trivia.dart';
import '../screens/quiz_screen.dart';
import '../screens/quiz_stats_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/quiz_history_screen.dart';
import '../pages/quiz_history_page.dart';
import '../models/quiz_result.dart';
import '../services/quiz_storage.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Trivia? triviaData;

  @override
  void initState() {
    super.initState();
    loadTrivia();
  }

  Future<void> loadTrivia() async {
    final trivia = await TriviaLoader.loadTodayTrivia();
    setState(() {
      triviaData = trivia;
    });
  }

  Future<bool> canPlayTodayQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPlayedDate = prefs.getString('lastQuizDate');

    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    return lastPlayedDate != todayStr;
  }

  @override
  Widget build(BuildContext context) {
    if (triviaData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  triviaData!.title,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.nanumGothic(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  triviaData!.description,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.nanumGothic(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Share.share('오늘의 Trivia 🤓\n\n${triviaData!.title}\n\n${triviaData!.description}\n\n하루 1분 상식 앱에서 가져왔어요!');
            },
            icon: const Icon(Icons.share),
            label: const Text('공유하기'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final allowed = await canPlayTodayQuiz();
              if (!allowed) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('오늘 퀴즈 완료'),
                    content: const Text('오늘은 이미 퀴즈를 풀었어요! 내일 다시 도전해 주세요.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizScreen()),
              );
            },
            child: const Text('오늘의 퀴즈'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizStatsScreen()),
              );
            },
            child: const Text('퀴즈 통계 보기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizHistoryScreen()),
              );
            },
            child: const Text('📅 최근 퀴즈 기록 보기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => QuizHistoryPage()));
            },
            child: const Text('퀴즈 기록 보기'),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('lastQuizDate');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('lastQuizDate 초기화됨')),
              );
            },
            child: const Text('🧪 퀴즈 날짜 초기화 (테스트용)'),
          ),
        ],
      ),
    );
  }
}
