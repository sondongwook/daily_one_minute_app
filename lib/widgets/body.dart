import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart'; // ✅ 공유 기능 추가
import 'package:google_fonts/google_fonts.dart'; // ✅ 폰트 기능 추가
import '../services/trivia_loader.dart'; // ✅ TriviaLoader로 대체
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
  String? todayTrivia;
  Trivia? triviaData;

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
      triviaData = trivia;
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
                    Share.share('오늘의 Trivia 🧓\n\n$todayTrivia\n\n하루 1분 상식 앱에서 가져왔어요!');
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

              // ✅ 퀴즈 결과 저장 처리 추가 (오늘 퀴즈 시작 전 저장)
              if (triviaData != null) {
                final result = QuizResult(
                  date: DateTime.now(),
                  question: triviaData!.question,
                  options: triviaData!.options,
                  selectedAnswer: '', // 아직 선택 전
                  correctAnswer: triviaData!.answer,
                  isCorrect: false, // 정답 여부는 결과 페이지에서 갱신 가능
                );
                await saveQuizResult(result);
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
            child: const Text('🗕 최근 퀴즈 기록 보기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => QuizHistoryPage()));
            },
            child: Text('퀴즈 기록 보기'),
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
