import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      color: Colors.black.withOpacity(0.05),
      alignment: Alignment.center,
      child: const Text(
        '📢 광고 배너 영역',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
