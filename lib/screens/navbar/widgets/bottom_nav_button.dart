import 'package:crypto_tutorial_app/providers/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_sizes.dart';

class BottomNavBTN extends StatelessWidget {
  final Function(int) onPressed;
  final IconData icon;
  final int index;
  final int currentIndex;


  const BottomNavBTN({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return InkWell(
      onTap: () {
        onPressed(index);
      },
      child: Container(
        height: AppSizes.blockSizeHorizontal * 13,
        width: AppSizes.blockSizeHorizontal * 17,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              opacity: (currentIndex == index) ? 1 : 0.2,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: Icon(
                icon,
                color: isDark ? CupertinoColors.black : CupertinoColors.white,
                size: AppSizes.blockSizeHorizontal * 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}