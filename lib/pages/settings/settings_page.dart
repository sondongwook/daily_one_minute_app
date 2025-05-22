import 'package:flutter/material.dart';
import 'app_info_page.dart';
import 'terms_page.dart';
import 'privacy_policy_page.dart';
import 'feedback_helper.dart';
import 'review_helper.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('앱 정보'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AppInfoPage()));
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.article_outlined),
            title: Text('이용약관'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => TermsPage()));
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('개인정보 처리방침'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => PrivacyPolicyPage()));
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.feedback_outlined),
            title: Text('피드백 보내기'),
            onTap: () {
              FeedbackHelper.sendFeedback(context);
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.star_border),
            title: Text('리뷰 남기기'),
            onTap: () {
              ReviewHelper.openStoreReview(context);
            },
          ),
        ],
      ),
    );
  }
}
