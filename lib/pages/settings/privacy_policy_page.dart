import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('개인정보 처리방침')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '''
[개인정보 처리방침]

‘하루 1분’ 앱(이하 "앱")은 이용자의 개인정보를 중요하게 생각하며, 다음과 같은 방침에 따라 개인정보를 처리합니다.

1. 수집하는 개인정보 항목
앱은 개인정보를 수집하지 않으며, 모든 기능은 로그인 없이 사용할 수 있습니다. 단, 향후 피드백 또는 서비스 개선을 위해 이메일을 수집할 수 있으며, 이 경우 별도 고지를 통해 동의를 받습니다.

2. 개인정보의 이용 목적
수집한 정보는 오직 피드백 응대, 오류 대응 등 서비스 개선을 위한 목적으로만 사용됩니다.

3. 개인정보의 보유 및 이용 기간
이용자의 개인정보는 수집 및 이용 목적이 달성된 후 지체 없이 파기합니다.

4. 제3자 제공 및 위탁
앱은 이용자의 동의 없이 개인정보를 외부에 제공하지 않으며, 위탁 처리하지 않습니다.

5. 이용자의 권리
이용자는 언제든지 자신의 개인정보를 열람, 수정, 삭제 요청할 수 있습니다.

6. 쿠키 사용
앱은 쿠키를 사용하지 않습니다.

7. 개인정보 보호 책임자
- 이메일: appdev1016@naver.com

이 방침은 향후 변경될 수 있으며, 변경 시 앱 내에 고지합니다.

[최종 업데이트: 2025년 5월]
''',
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
      ),
    );
  }
}
