import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzData.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);

    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> scheduleDailyTriviaNotification() async {
    await _notificationsPlugin.zonedSchedule(
      0,
      '오늘의 Trivia!',
      '하루 1분 상식 확인하러 가볼까요?',
      _nextInstanceOfEightAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel_id',
          'Daily Notifications',
          channelDescription: '매일 오전 8시에 Trivia 알림',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // 테스트 알림 함수
  static Future<void> showNow() async {
    await _notificationsPlugin.show(
      1,
      '테스트 알림',
      '지금 알림이 잘 오나요?',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: '테스트용 즉시 알림',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static tz.TZDateTime _nextInstanceOfEightAM() {
    final now = tz.TZDateTime.now(tz.local);
    final scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 8); // 아침 8시 알람
    return now.isBefore(scheduled) ? scheduled : scheduled.add(const Duration(days: 1));
  }
}
