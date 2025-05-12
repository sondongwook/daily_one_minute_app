import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/body.dart';
import '../widgets/footer.dart';
import '../notification_service.dart'; // ✅ 추가

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final trivia = await TriviaLoader.loadTodayTrivia();
      if (trivia != null) {
        context.read<TriviaProvider>().setTodayTrivia(trivia);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            Header(),
            Expanded(child: Body()),
            Footer(),
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
}
