import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewHelper {
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.app';
  static const String _appStoreUrl = 'https://apps.apple.com/app/id1234567890';

  static Future<void> openStoreReview(BuildContext context) async {
    // 플랫폼에 따라 링크 분기
    final Uri uri = Uri.parse(
      Theme.of(context).platform == TargetPlatform.iOS ? _appStoreUrl : _playStoreUrl,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스토어를 열 수 없습니다.')),
      );
    }
  }
}
