import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../widget/drawer/home_drawer.dart';
import '../widget/home_market_tab.dart';
import '../widget/home_search_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends ConsumerState<HomeScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const HomeDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 6, top: 6, right: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EXISTING SEARCH BAR - UNCHANGED
            HomeSearchBar(
              isDark: isDark,
              onTap: () {
                context.pushNamed(RouteNames.marketSearchName);
              },
            ),

            SizedBox(height: 8.h),

            ElevatedButton(
              onPressed: () {
                context.pushNamed(RouteNames.registerName);
              },
              child: const Text('Create Account'),
            ),

            Expanded(
              child: HomeMarketTab(
                isDark: isDark,
              ),
            ),


          ],
        ),
      ),
    );
  }
}




