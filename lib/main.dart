import 'dart:io'; // ⬅️ 추가
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'notification_service.dart';
import 'utils/app_colors.dart'; // ✅ 앱 전체 테마 추가
import 'package:provider/provider.dart';
import 'providers/trivia_provider.dart';

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TriviaProvider()),
      ],
      child: const DailyOneMinuteApp(),
    ),
  );
}

class DailyOneMinuteApp extends StatelessWidget {
  const DailyOneMinuteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '하루1분',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.accent,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
