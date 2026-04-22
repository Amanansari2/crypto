import 'package:crypto_app/core/theme/theme_mode_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          SizedBox(height: 100.h),
          ThemeModeChips(),
          SizedBox(height: 100.h),
          Center(child: Text(title, style: const TextStyle(fontSize: 20))),
        ],
      ),
    );
  }
}
