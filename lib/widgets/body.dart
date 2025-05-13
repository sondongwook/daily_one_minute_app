import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/trivia_loader.dart';
import '../services/quiz_loader.dart';
import '../models/trivia.dart';
import '../models/quiz.dart';
import '../screens/quiz_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_result.dart';
import '../services/quiz_storage.dart';
import '../pages/quiz_history_page.dart';

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

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF002942), Color(0xFF005473)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.lightbulb, size: 48, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                '오늘의 상식',
                style: GoogleFonts.nanumGothic(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                triviaData!.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nanumGothic(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                triviaData!.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.nanumGothic(
                  fontSize: 16,
                  height: 1.6,
                  letterSpacing: 0.3,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Divider(height: 32, thickness: 0.5, color: Colors.white24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconButton(Icons.share, '공유', () {
                    Share.share(
                      '오늘의 Trivia 🤓\n\n${triviaData!.title}\n\n${triviaData!.description}\n\n하루 1분 상식 앱에서 가져왔어요!',
                    );
                  }),
                  _buildIconButton(Icons.quiz, '퀴즈', () async {
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

                    final quiz = await QuizLoader.loadTodayQuiz();
                    if (quiz == null) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('퀴즈 없음'),
                          content: const Text('오늘의 퀴즈가 아직 준비되지 않았어요.'),
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
                      MaterialPageRoute(
                        builder: (context) => const QuizScreen(),
                        settings: RouteSettings(arguments: quiz),
                      ),
                    );
                  }),
                  _buildIconButton(Icons.history, '기록', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QuizHistoryPage()),
                    );
                  }),
                  _buildIconButton(Icons.refresh, '초기화', () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('lastQuizDate');
                    await prefs.remove('quiz_results');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('퀴즈 기록과 날짜가 초기화되었습니다.')),
                    );
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 28, color: Colors.tealAccent),
          onPressed: onPressed,
          splashRadius: 24,
        ),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
