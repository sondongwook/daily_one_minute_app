import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoPage extends StatefulWidget {
  @override
  _AppInfoPageState createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  String appName = '';
  String version = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appName = info.appName;
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('앱 정보')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('앱 이름: $appName', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('버전: $version', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('빌드 번호: $buildNumber', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text('개발자: 하루 1분 팀', style: TextStyle(fontSize: 16)),
            Text('문의: appdev1016@naver.com', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
