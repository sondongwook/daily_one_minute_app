import 'package:flutter/material.dart';
import 'trivia_history_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Trivia 히스토리 보기'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TriviaHistoryScreen()),
              );
            },
          ),
          // 다른 설정 항목들...
        ],
      ),
    );
  }
}
