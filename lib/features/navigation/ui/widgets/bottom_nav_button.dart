import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavButton extends StatelessWidget {
  final Function(int) onPressed;
  final IconData icon;
  final int index;
  final int currentIndex;

  const BottomNavButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;

    return InkWell(
      onTap: () => onPressed(index),
      child: SizedBox(
        height: 50.h,
        width: 60.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isActive)
              Positioned(
                bottom: 6.h,
                child: Icon(
                  icon,
                  color: Colors.black,
                  size: 22.sp,
                ),
              ),

            AnimatedOpacity(
              opacity: isActive ? 1 : 0.3,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: Icon(
                icon,
                color: Colors.yellow[300],
                size: 22.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}