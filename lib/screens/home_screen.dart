import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/body.dart';
import '../widgets/footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            Header(),
            Expanded(child: Body()),
            Footer(),
          ],
        ),
      ),
    );
  }
}
