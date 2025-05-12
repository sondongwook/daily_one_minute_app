import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text(
        '© 하루1분, 2025',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
