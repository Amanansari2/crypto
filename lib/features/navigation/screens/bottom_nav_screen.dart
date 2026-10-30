//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
//
//
// class MainWrapper extends ConsumerWidget {
//   final StatefulNavigationShell navigationShell;
//
//   const MainWrapper({
//     super.key,
//     required this.navigationShell,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentIndex = navigationShell.currentIndex;
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     const inactiveColor = Color(0xFF9CA8BC);
//     const activeColor = Color(0xFF1685FF);
//
//     void selectTab(int index) {
//       navigationShell.goBranch(
//         index,
//         initialLocation: index == currentIndex,
//       );
//     }
//
//     Widget navItem({
//       required int index,
//       required IconData icon,
//       required String label,
//     }) {
//       final isActive = currentIndex == index;
//
//       return Expanded(
//         child: GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: () => selectTab(index),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   boxShadow: isActive
//                       ? [
//                     BoxShadow(
//                       color: activeColor.withOpacity(0.45),
//                       blurRadius: 14,
//                       spreadRadius: 1,
//                     ),
//                   ]
//                       : [],
//                 ),
//                 child: Icon(
//                   icon,
//                   size: 18.sp,
//                   color: isActive ? activeColor : inactiveColor,
//                 ),
//               ),
//               SizedBox(height: 5.h),
//               Text(
//                 label,
//                 maxLines: 1,
//                 style: TextStyle(
//                   fontSize: 10.sp,
//                   fontWeight:
//                   isActive ? FontWeight.w600 : FontWeight.w400,
//                   color: isActive ? activeColor : inactiveColor,
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       // extendBody: true,
//       body: navigationShell,
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             height: 0.5.h,
//             // color: const Color(0xFF203047),
//             color: Colors.blue.withOpacity(0.4),
//           ),
//
//           Padding(
//             padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 8.h),
//             child: SizedBox(
//               height: 55.h,
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 alignment: Alignment.center,
//                 children: [
//                   // Main rounded navigation background.
//
//                   // Five navigation positions.
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 9.w),
//                     child: Row(
//                       children: [
//                         navItem(
//                           index: 0,
//                           icon: CupertinoIcons.house_fill,
//                           label: 'Home',
//                         ),
//                         navItem(
//                           index: 1,
//                           icon: CupertinoIcons.chart_bar_fill,
//                           label: 'Markets',
//                         ),
//
//                         // Space reserved for the raised Trade button.
//                         const Expanded(
//                           child: SizedBox(),
//                         ),
//
//                         navItem(
//                           index: 3,
//                           icon: CupertinoIcons.creditcard_fill,
//                           label: 'Wallet',
//                         ),
//                         navItem(
//                           index: 4,
//                           icon: CupertinoIcons.doc_text_fill,
//                           label: 'Setting',
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Raised center Trade button.
//                   Positioned(
//                     top: -20.h,
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () => selectTab(2),
//                       child: SizedBox(
//                         width: 78.w,
//                         height: 75.h,
//                         child: Column(
//                           children: [
//                             Container(
//                               width: 50.w,
//                               height: 50.w,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 gradient: const LinearGradient(
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                   colors: [
//                                     Color(0xFF4387FF),
//                                     Color(0xFF0062F5),
//                                   ],
//                                 ),
//                                 border: Border.all(
//                                   color: const Color(0xFF8AB8FF),
//                                   width: 1.5,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: activeColor.withOpacity(0.45),
//                                     blurRadius: 18,
//                                     spreadRadius: 2,
//                                   ),
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.45),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: Icon(
//                                 CupertinoIcons.arrow_left_right,
//                                 color: Colors.white,
//                                 size: 20.sp,
//                               ),
//                             ),
//                             const Spacer(),
//                             Text(
//                               'Trade',
//                               style: TextStyle(
//                                 color: currentIndex == 2
//                                     ? activeColor
//                                     : (isDark
//                                     ? Colors.white
//                                     : Theme.of(context)
//                                     .colorScheme
//                                     .onSurface),
//                                 fontSize: 10.sp,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


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
