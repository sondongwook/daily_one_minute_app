import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/body.dart';
import '../widgets/footer.dart';
import '../notification_service.dart'; // ✅ 추가

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
