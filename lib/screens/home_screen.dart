import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/header.dart';
import '../widgets/body.dart';
import '../widgets/footer.dart';
import '../notification_service.dart'; // ✅ 추가
import '../services/trivia_loader.dart';
import '../providers/trivia_provider.dart';

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