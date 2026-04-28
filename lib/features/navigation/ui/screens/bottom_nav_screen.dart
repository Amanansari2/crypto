// import 'package:crypto_app/core/utils/constants/app_colors.dart';
// import 'package:crypto_app/shared/widgets/clippers/custom_Clipper.dart';
// import 'package:crypto_app/core/theme/theme_provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../../sample_widget.dart';
// import '../../logic/helpers/nav_animation_helper.dart';
// import '../../logic/provider/nav_provider.dart';
// import '../widgets/bottom_nav_button.dart';
//
// class BottomNavScreen extends ConsumerStatefulWidget {
//   const BottomNavScreen({super.key, });
//
//
//   @override
//   ConsumerState<BottomNavScreen> createState() => _BottomNavScreenState();
// }
//
// class _BottomNavScreenState extends ConsumerState<BottomNavScreen> {
//   final PageController pageController = PageController();
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   }
//
//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }
//
//   void animateToPage(int page) {
//     pageController.animateToPage(
//       page,
//       duration: const Duration(
//         milliseconds: 400,
//       ),
//       curve: Curves.decelerate,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
// final currentIndex = ref.watch(navProvider).index;
//
// final screens = [
//   const SampleWidget(label: 'HOME', color: Colors.deepPurpleAccent),
//   const SampleWidget(label: 'SEARCH', color: Colors.amber),
//   const SampleWidget(label: 'EXPLORE', color: Colors.cyan),
// ];
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.grey[900],
//         title: const Text(
//           "Custom Bottom Navigation Bar",
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           onPressed: (){
//             ref.read(themeProvider.notifier).toggleTheme();
//           },
//           icon: Icon(
//             Theme.of(context).brightness == Brightness.light
//                 ? Icons.dark_mode
//                 : Icons.light_mode,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(
//               child: PageView(
//             onPageChanged: (value) {
//                ref.read(navProvider.notifier).setIndex(value);
//             },
//             controller: pageController,
//             children: screens,
//           )),
//           Positioned(
//             bottom: 10,
//             right: 0,
//             left: 0,
//             child: bottomNav(currentIndex, context  ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget bottomNav(int currentIndex, BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(
//         16.w, 0,
//           16.w, 0),
//       child: Material(
//         borderRadius: BorderRadius.circular(30),
//         color: Colors.transparent,
//         elevation: 6,
//         child: Container(
//             height: 70.h,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 0,
//                   bottom: 0,
//                   left: 12.w,
//                   right: 12.w,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       BottomNavButton(
//                         onPressed: (val) {
//                           animateToPage(val);
//
//                         },
//                         icon: CupertinoIcons.house,
//                         currentIndex: currentIndex,
//                         index: 0,
//                       ),
//                       BottomNavButton(
//                         onPressed: (val) {
//                           animateToPage(val);
//                         },
//                         icon: CupertinoIcons.search,
//                         currentIndex: currentIndex,
//                         index: 1,
//                       ),
//                       BottomNavButton(
//                         onPressed: (val) {
//                           animateToPage(val);
//                         },
//                         icon: CupertinoIcons.square_favorites_alt,
//                         currentIndex: currentIndex,
//                         index: 2,
//                       ),
//
//                     ],
//                   ),
//                 ),
//                 AnimatedPositioned(
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.decelerate,
//                     // top: 0,
//                     bottom: 0,
//                     left: animatedPositionedLEftValue(currentIndex, context),
//                     child: Column(
//                       children: [
//
//                         ClipPath(
//                           clipper: MyCustomClipper(),
//                           child: Container(
//                             height: 60.h,
//                             width: 50.w,
//                             decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                               begin: Alignment.bottomCenter,
//                               end: Alignment.topCenter,
//                               colors: AppColors.navGradient,
//                             )),
//                           ),
//                         ),
//                          Container(
//                           height: 4.h,
//                           width: 50.w,
//                           decoration: BoxDecoration(
//                             color: Colors.yellow,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                       ],
//                     ))
//               ],
//             )),
//       ),
//     );
//   }
// }



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../shared/widgets/clippers/custom_Clipper.dart';
import '../../logic/helpers/nav_animation_helper.dart';
import '../widgets/bottom_nav_button.dart';

class MainWrapper extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: Theme
                .of(context)
                .colorScheme
                .surface,
            borderRadius: BorderRadius.circular(30),

            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 25,
                spreadRadius: 1,
              )
            ],
          ),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BottomNavButton(
                    index: 0,
                    currentIndex: currentIndex,
                    icon: CupertinoIcons.house,
                    onPressed: (i) => navigationShell.goBranch(i),
                  ),
                  BottomNavButton(
                    index: 1,
                    currentIndex: currentIndex,
                    icon: CupertinoIcons.search,
                    onPressed: (i) => navigationShell.goBranch(i),
                  ),
                  BottomNavButton(
                    index: 2,
                    currentIndex: currentIndex,
                    icon: CupertinoIcons.square_favorites_alt,
                    onPressed: (i) => navigationShell.goBranch(i),
                  ),
                ],
              ),

              /// Indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: animatedPositionedLEftValue(currentIndex, context),
                bottom: 0,
                child: Column(
                  children: [
                    ClipPath(
                      clipper: MyCustomClipper(),
                      child: Container(
                        height: 60.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                            gradient: AppColors.navGradient
                        ),
                      ),
                    ),
                    Container(
                      height: 4.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}