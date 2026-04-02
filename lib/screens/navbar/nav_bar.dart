import 'package:crypto_tutorial_app/providers/theme/theme_provider.dart';
import 'package:crypto_tutorial_app/screens/navbar/provider/nav_provider.dart';
import 'package:crypto_tutorial_app/screens/navbar/widgets/bottom_nav_button.dart';
import 'package:crypto_tutorial_app/screens/navbar/widgets/clipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/app_sizes.dart';
import '../../core/constants.dart';


class NavBar extends StatefulWidget {
  const NavBar({super.key, });


  @override
  State<NavBar> createState() => _HomeViewState();
}

class _HomeViewState extends State<NavBar> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void animateToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(
        milliseconds: 400,
      ),
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final currentIndex = context.watch<NavProvider>().index;
    AppSizes().init(context);
    return Scaffold(
      // backgroundColor:isDark? CupertinoColors.black : CupertinoColors.white,
      body: Stack(
        children: [
          Positioned.fill(
              child: PageView(
                onPageChanged: (value) {
                  context.read<NavProvider>().setIndex(value);
                },
                controller: pageController,
                children: screens,
              )),
          Positioned(
            bottom: 10,
            right: 0,
            left: 0,
            child: bottomNav(currentIndex, context, isDark  ),
          ),
        ],
      ),
    );
  }

  Widget bottomNav(int currentIndex, BuildContext context, bool isDark,) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          AppSizes.blockSizeHorizontal * 4.5, 0,
          AppSizes.blockSizeHorizontal * 4.5, 0),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
        elevation: 6,
        child: Container(
            height: AppSizes.blockSizeHorizontal * 18,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Colors.black ,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: AppSizes.blockSizeHorizontal * 3,
                  right: AppSizes.blockSizeHorizontal * 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BottomNavBTN(
                        onPressed: (val) {
                          context.read<NavProvider>().setIndex(val);

                          animateToPage(val);

                        },
                        icon: CupertinoIcons.house,
                        currentIndex: currentIndex,
                        index: 0,
                      ),
                      BottomNavBTN(
                        onPressed: (val) {
                          animateToPage(val);
                        },
                        icon: CupertinoIcons.search,
                        currentIndex: currentIndex,
                        index: 1,
                      ),
                      BottomNavBTN(
                        onPressed: (val) {
                          animateToPage(val);
                        },
                        icon: CupertinoIcons.square_favorites_alt,
                        currentIndex: currentIndex,
                        index: 2,
                      ),

                    ],
                  ),
                ),
                AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                    // top: 0,
                    bottom: 0,
                    left: animatedPositionedLEftValue(currentIndex, context),
                    child: Column(
                      children: [

                        ClipPath(
                          clipper: MyCustomClipper(),
                          child: Container(
                            height: AppSizes.blockSizeHorizontal * 15,
                            width: AppSizes.blockSizeHorizontal * 12,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: gradient,
                                )),
                          ),
                        ),
                        Container(
                          height: AppSizes.blockSizeHorizontal * 1,
                          width: AppSizes.blockSizeHorizontal * 12,
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}