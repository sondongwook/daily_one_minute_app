import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackHelper {
  static Future<void> sendFeedback(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'appdev1016@naver.com',
      queryParameters: {
        'subject': '하루 1분 앱 피드백',
        'body': '아래에 피드백을 적어주세요.\n\n앱 버전:\n사용 중 불편한 점 또는 제안사항:\n',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 앱을 열 수 없습니다.')),
      );
    }
  }
}
