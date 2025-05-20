import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quiz_result.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class QuizHistoryPage extends StatefulWidget {
  @override
  State<QuizHistoryPage> createState() => _QuizHistoryPageState();
}

class _QuizHistoryPageState extends State<QuizHistoryPage> {
  List<QuizResult> results = [];

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('quiz_results') ?? [];
    final parsed = data.map((e) => QuizResult.fromJson(jsonDecode(e))).toList();
    setState(() {
      results = parsed.reversed.toList(); // 최신 순
    });
  }

  Map<String, List<QuizResult>> groupByMonth(List<QuizResult> list) {
    Map<String, List<QuizResult>> groups = {};
    for (var result in list) {
      final key = DateFormat('yyyy-MM').format(result.date);
      groups.putIfAbsent(key, () => []).add(result);
    }
    return groups;
  }

  Widget buildStatisticsCard(List<QuizResult> monthly) {
    if (monthly.isEmpty) return SizedBox.shrink();

    final correct = monthly.where((r) => r.isCorrect).length;
    final averageTime = monthly.map((r) => r.duration.inSeconds).fold(0, (a, b) => a + b) / monthly.length;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이번 달 퀴즈 통계', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('정답률: ${(correct / monthly.length * 100).toStringAsFixed(1)}%'),
            Text('푼 문제 수: ${monthly.length}개'),
            Text('평균 소요 시간: ${averageTime.toStringAsFixed(1)}초'),
          ],
        ),
      ),
    );
  }

  Widget buildBarChart(Map<String, List<QuizResult>> monthlyGroups) {
    final sortedKeys = monthlyGroups.keys.toList()..sort();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: BarChart(
          BarChartData(
            barGroups: List.generate(sortedKeys.length, (index) {
              final month = sortedKeys[index];
              final total = monthlyGroups[month]!.length;
              final correct = monthlyGroups[month]!.where((r) => r.isCorrect).length;
              final ratio = total == 0 ? 0.0 : correct / total * 100;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(toY: ratio, width: 14, color: Colors.blue),
                ],
              );
            }),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index < 0 || index >= sortedKeys.length) return SizedBox.shrink();
                    final label = sortedKeys[index].substring(5); // MM
                    return Text(label, style: TextStyle(fontSize: 10));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 30),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: true),
            barTouchData: BarTouchData(enabled: true),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonthKey = DateFormat('yyyy-MM').format(now);
    final monthlyGroups = groupByMonth(results);
    final currentMonthResults = monthlyGroups[currentMonthKey] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('퀴즈 기록')),
      body: results.isEmpty
          ? Center(child: Text('아직 기록이 없습니다.'))
          : ListView(
              children: [
                buildStatisticsCard(currentMonthResults),
                buildBarChart(monthlyGroups),
                const Divider(),
                ...results.map((r) {
                  final formattedDate = DateFormat('yyyy-MM-dd').format(r.date);
                  return ListTile(
                    title: Text(r.question, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('정답: ${r.correctAnswer} • 날짜: $formattedDate'),
                    trailing: Icon(
                      r.isCorrect ? Icons.check_circle : Icons.cancel,
                      color: r.isCorrect ? Colors.green : Colors.red,
                    ),
                  );
                }).toList(),
              ],
            ),
    );
  }
}
