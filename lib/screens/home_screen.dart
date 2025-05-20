import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/header.dart';
import '../widgets/body.dart';
import '../widgets/footer.dart';
import '../notification_service.dart'; // ✅ 추가
import '../services/trivia_loader.dart';
import '../providers/trivia_provider.dart';
import 'quiz_screen.dart';
import '../sample/sample_quiz_screen_remote.dart'; // ✅ 샘플 퀴즈 화면 import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final trivia = await TriviaLoader.loadTodayTrivia();
      if (trivia != null) {
        context.read<TriviaProvider>().setTodayTrivia(trivia);
      } else {
        // 오류 처리 or 대체 메시지
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(child: Body()),
            const Footer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TextButton(
                child: const Text("샘플 문제 풀기"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SampleQuizScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NotificationService.showNow(); // ✅ 테스트 알림 실행
        },
        child: const Icon(Icons.notifications),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Column(
  //         children: const [
  //           Header(),
  //           Expanded(child: Body()),
  //           Footer(),
  //         ],
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         NotificationService.showNow(); // ✅ 테스트 알림 실행
  //       },
  //       child: const Icon(Icons.notifications),
  //     ),
  //   );
  // }
}