import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart'; // ✅ 공유기능 추가

class TriviaHistoryScreen extends StatefulWidget {
  const TriviaHistoryScreen({super.key});

  @override
  State<TriviaHistoryScreen> createState() => _TriviaHistoryScreenState();
}

class _TriviaHistoryScreenState extends State<TriviaHistoryScreen> {
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final storedHistory = prefs.getStringList('triviaHistory') ?? [];

  print("📌 로드된 히스토리 수: ${storedHistory.length}"); // ✅ 디버그용

  setState(() {
      history = storedHistory.reversed.toList(); // 최신순 정렬
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Trivia 히스토리')),
        body: history.isEmpty
            ? const Center(child: Text('히스토리가 비어있습니다.'))
            : ListView(
                children: history.map((entry) {
                  final parts = entry.split('|');
                  return ListTile(
                    title: Text(parts.length > 1 ? parts[1] : entry),
                    subtitle: Text(parts.length > 0 ? parts[0] : ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        final date = parts.length > 0 ? parts[0] : '';
                        final content = parts.length > 1 ? parts[1] : entry;

                        Share.share('📅 $date 의 Trivia 🤓\n\n$content\n\n하루 1분 상식 앱에서 가져왔어요!');
                      },
                    ),
                  );
                }).toList(),
            ),
    );
  }
}
