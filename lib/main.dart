import 'dart:io'; // ⬅️ 추가
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  // ✅ 시뮬레이터에서는 알림 예약 실행 안 함
  if (Platform.isAndroid || Platform.isIOS) {
    try {
      await NotificationService.scheduleDailyTriviaNotification();
    } catch (e) {
      print('⚠️ 알림 예약 실패: $e');
    }
  } else {
    print('🛑 시뮬레이터 환경 - 알림 예약 생략');
  }

  runApp(const DailyOneMinuteApp());
}

class DailyOneMinuteApp extends StatelessWidget {
  const DailyOneMinuteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '하루1분',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
