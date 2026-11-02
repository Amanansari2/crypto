import 'package:crypto_app/features/contents/widgets/about_us_screen.dart';
import 'package:crypto_app/features/home/ui/screen/home_screen.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/indicator_settings_sheet.dart';
import 'package:crypto_app/features/market/ui/screens/market_detail_screen.dart';
import 'package:crypto_app/features/market/ui/screens/market_screen.dart';
import 'package:crypto_app/features/trade/ui/screen/trade_screen.dart';
import 'package:crypto_app/features/wallet/ui/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/ui/screen/forgot_password_screen.dart';
import '../../features/authentication/ui/screen/login_screen.dart';
import '../../features/authentication/ui/screen/otp_screen.dart';
import '../../features/authentication/ui/screen/register_screen.dart';
import '../../features/authentication/ui/screen/reset_otp_screen.dart';
import '../../features/authentication/ui/screen/reset_password_screen.dart';
import '../../features/contents/widgets/faq_screen.dart';
import '../../features/contents/widgets/privacy_policy_screen.dart';
import '../../features/contents/widgets/refund_policy_screen.dart';
import '../../features/contents/widgets/reward_referral_policy_screen.dart';
import '../../features/contents/widgets/subscription_policy_screen.dart';
import '../../features/contents/widgets/term_condition_screen.dart';
import '../../features/market/chart_engine/ui/widgets/interval/custom_inetrval.dart';
import '../../features/market/ui/screens/search_screen.dart';
import '../../features/navigation/screens/bottom_nav_screen.dart';
import '../../features/onboarding/ui/screen/onboarding_screen.dart';
import '../../features/trade_history/ui/trading_history_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  // Root navigator
  static final rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'rootNav',
  );

  // 0. Home
  static final homeNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'homeNav',
  );

  // 1. Markets
  static final marketNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'marketNav',
  );

  // 2. Trade
  static final tradeNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'tradeNav',
  );

  // 3. Wallet
  static final walletNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'walletNav',
  );

  // 4. Settings
  // static final settingsNavigatorKey = GlobalKey<NavigatorState>(
  //   debugLabel: 'settingsNav',
  // );
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
          // 0. HOME
          StatefulShellBranch(
            navigatorKey: AppRouter.homeNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.home,
                name: RouteNames.homeName,
                builder: (context, state) =>
                const HomeScreen(),
              ),
            ],
          ),

          // 1. MARKETS
          StatefulShellBranch(
            navigatorKey: AppRouter.marketNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.market,
                name: RouteNames.marketName,
                builder: (context, state) => const MarketScreen(),
              ),
            ],
          ),

          // 2. TRADE
          StatefulShellBranch(
            navigatorKey: AppRouter.tradeNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.trade,
                name: RouteNames.tradeName,
                builder: (context, state) => const TradeScreen(),
              ),
            ],
          ),

          // 3. WALLET
          StatefulShellBranch(
            navigatorKey: AppRouter.walletNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.wallet,
                name: RouteNames.walletName,
                builder: (context, state) =>
                const WalletScreen(accountId: 'DEMO001'),
              ),
            ],
          ),

        ],
      ),

      GoRoute(
        path: RouteNames.marketDetail,
        name: RouteNames.marketDetailName,
        builder: (context, state) {
          final symbol = state.pathParameters['symbol']!;
          return MarketDetailScreen(symbol: symbol);
        },
      ),
      GoRoute(
        path: RouteNames.marketSearch,
        name: RouteNames.marketSearchName,
        builder: (context, state) => const SearchScreen(),
      ),

      GoRoute(

        path: RouteNames.customInterval,
        name: RouteNames.customIntervalName,

        builder: (context, state) {
          return  CustomIntervalScreen();
        },
      ),

      GoRoute(

        path: RouteNames.customIndicator,
        name: RouteNames.customIndicatorName,

        builder: (context, state) {
          return  IndicatorSettingsSheet();
        },
      ),

      GoRoute(
        path: RouteNames.tradingHistory,
        name: RouteNames.tradingHistoryName,
        builder: (context, state) => const TradingHistoryScreen(),
      ),

      GoRoute(
        path: RouteNames.termsCondition,
        name: RouteNames.termsConditionName,
        builder: (context, state) => const TermsConditionScreen(),
      ),

      GoRoute(
        path: RouteNames.privacyPolicy,
        name: RouteNames.privacyPolicyName,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),

      GoRoute(
        path: RouteNames.refundPolicy,
        name: RouteNames.refundPolicyName,
        builder: (context, state) => const RefundPolicyScreen(),
      ),

      GoRoute(
        path: RouteNames.rewardReferralPolicy,
        name: RouteNames.rewardReferralPolicyName,
        builder: (context, state) =>
        const RewardReferralPolicyScreen(),
      ),

      GoRoute(
        path: RouteNames.subscriptionPolicy,
        name: RouteNames.subscriptionPolicyName,
        builder: (context, state) => const SubscriptionPolicyScreen(),
      ),

      GoRoute(
        path: RouteNames.faq,
        name: RouteNames.faqName,
        builder: (context, state) => const FaqScreen(),
      ),

      GoRoute(
        path: RouteNames.aboutUs,
        name: RouteNames.aboutUsName,
        builder: (context, state) => const AboutUsScreen(),
      ),


      //authentication

      GoRoute(
        path: RouteNames.signIn,
        name: RouteNames.signInName,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: RouteNames.register,
        name: RouteNames.registerName,
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: RouteNames.otp,
        name: RouteNames.otpName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return OtpScreen(
              email: extra['email'] as String,
              password : extra['password'] as String
          );
        },
      ),

      GoRoute(
        path: RouteNames.forgotPassword,
        name: RouteNames.forgotPasswordName,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: RouteNames.resetOtp,
        name: RouteNames.resetOtpName,
        builder: (context, state) {
          final email = state.extra as String;

          return ResetOtpScreen(email: email);
        },
      ),

      GoRoute(
        path: RouteNames.resetPassword,
        name: RouteNames.resetPasswordName,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
    ],
  );
});
