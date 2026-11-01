


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;
    final colors = Theme.of(context).colorScheme;

    const activeColor = Color(0xFF1685FF);
    const inactiveColor = Color(0xFF9CA8BC);

    void selectTab(int index) {
      navigationShell.goBranch(
        index,
        initialLocation: index == currentIndex,
      );
    }

    Widget navItem({
      required int index,
      required IconData icon,
      required String label,
    }) {
      final isActive = currentIndex == index;

      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => selectTab(index),
          child: SizedBox(
            height: 60.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22.sp,
                  color: isActive ? activeColor : inactiveColor,
                ),
                SizedBox(height: 5.h),
                Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: isActive
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: isActive
                        ? activeColor
                        : inactiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(
              color: colors.outlineVariant.withOpacity(0.5),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 4.h,
            ),
            child: Row(
              children: [
                navItem(
                  index: 0,
                  icon: CupertinoIcons.house_fill,
                  label: 'Home',
                ),
                navItem(
                  index: 1,
                  icon: CupertinoIcons.chart_bar_fill,
                  label: 'Markets',
                ),
                navItem(
                  index: 2,
                  icon: CupertinoIcons.arrow_left_right,
                  label: 'Trade',
                ),
                navItem(
                  index: 3,
                  icon: CupertinoIcons.creditcard_fill,
                  label: 'Wallet',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
