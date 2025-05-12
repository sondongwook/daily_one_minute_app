import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
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
