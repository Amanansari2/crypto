import 'package:crypto_app/features/market/ui/screens/market_detail_screen.dart';
import 'package:crypto_app/features/market/ui/screens/market_screen.dart';
import 'package:crypto_app/placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/navigation/ui/screens/bottom_nav_screen.dart';
import '../../features/onboarding/ui/screen/onboarding_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  /// Navigator Keys
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final homeNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'homeNav',
  );
  static final settingsNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'settingsNav',
  );

  static final marketNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'marketNav',
  );
}

/// Riverpod Provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.onboarding,
    debugLogDiagnostics: true,
    navigatorKey: AppRouter.rootNavigatorKey,

    routes: [
      GoRoute(
        path: RouteNames.onboarding,
        name: "Onboarding",
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },

        branches: [
          /// HOME
          StatefulShellBranch(
            navigatorKey: AppRouter.homeNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.home,
                name: "Home",
                builder: (context, state) =>
                    const PlaceholderScreen(title: "home"),

                routes: [
                  GoRoute(
                    path: RouteNames.subHome,
                    name: "SubHome",
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const PlaceholderScreen(title: "subhome"),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// SETTINGS
          StatefulShellBranch(
            navigatorKey: AppRouter.settingsNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.settings,
                name: "Settings",
                builder: (context, state) =>
                    const PlaceholderScreen(title: "settings"),

                routes: [
                  GoRoute(
                    path: RouteNames.subSettings,
                    name: "SubSettings",
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const PlaceholderScreen(title: "subSetting"),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: AppRouter.marketNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.market,
                name: "Markets",
                builder: (context, state) => const MarketScreen(),

                routes: [
                  GoRoute(
                      path: RouteNames.marketDetail,
                      name: RouteNames.marketDetailName,
                      builder: (context, state) {
                        final symbol = state.pathParameters['symbol']!;
                        return MarketDetailScreen(symbol: symbol);
                      }
                  )
                ],
              ),
            ],
          ),
        ],
      ),

      /// PLAYER (root level)
      // GoRoute(
      //   parentNavigatorKey: AppRouter.rootNavigatorKey,
      //   path: RouteNames.player,
      //   name: "Player",
      //   builder: (context, state) =>
      //       PlayerView(key: state.pageKey),
      // ),
    ],
  );
});
