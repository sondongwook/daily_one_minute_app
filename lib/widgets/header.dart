import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/settings/settings_page.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF002942), Color(0xFF005473)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('하루1분',
                      style: GoogleFonts.nanumGothic(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color.primary,
                      )),
                  Text('매일 한 번, 새로운 지식',
                      style: GoogleFonts.nanumGothic(
                        fontSize: 13,
                        color: color.secondary,
                      )),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
            tooltip: '설정',
          )
        ],
      ),
    );
  }
}
