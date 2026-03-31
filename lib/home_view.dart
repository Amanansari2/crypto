import 'package:crypto_app/app/navigations/custom_Clipper.dart';
import 'package:crypto_app/app/navigations/nav_notifier.dart';
import 'package:crypto_app/app/widgets/bottom_nav_button.dart';
import 'package:crypto_app/app/widgets/constants.dart';
import 'package:crypto_app/providers/theme_provider.dart';
import 'package:crypto_app/utils/constants/size.config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key, });


  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
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
final currentIndex = ref.watch(navProvider).index;
    AppSizes().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Custom Bottom Navigation Bar",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: (){
            ref.read(themeProvider.notifier).toggleTheme();
          },
          icon: Icon(
            Theme.of(context).brightness == Brightness.light
                ? Icons.dark_mode
                : Icons.light_mode,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: PageView(
            onPageChanged: (value) {
               ref.read(navProvider.notifier).setIndex(value);
            },
            controller: pageController,
            children: screens,
          )),
          Positioned(
            bottom: 10,
            right: 0,
            left: 0,
            child: bottomNav(currentIndex, context  ),
          ),
        ],
      ),
    );
  }

  Widget bottomNav(int currentIndex, BuildContext context) {
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
              color: Colors.grey[900],
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
                            color: Colors.yellow,
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