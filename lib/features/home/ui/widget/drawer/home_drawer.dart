
import 'package:crypto_app/app/router/route_names.dart';
import 'package:crypto_app/core/theme/theme_provider.dart';
import 'package:crypto_app/core/utils/enums/app_theme_type.dart';
import 'package:crypto_app/shared/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_images.dart';
import '../../../../authentication/data/providers/logout_provider.dart';
import 'drawer_menu_item.dart';


final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  try {
    return await PackageInfo.fromPlatform();
  } catch (e, stackTrace) {
    debugPrint('PACKAGE INFO ERROR: $e');
    debugPrintStack(stackTrace: stackTrace);
    rethrow;
  }
});


class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  static const Color primaryBlue = Color(0xFF0878FF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final user = ref.read(currentUserProvider);
    final token = ref.read(localStorageProvider).getToken();

    final isLoggedIn = token != null && token.trim().isNotEmpty;

    final selectedTheme = ref.watch(themeProvider);

    final borderColor = isDark
        ? const Color(0xFF1D3046)
        : const Color(0xFFE1E8F2);

    final packageInfoAsync = ref.watch(packageInfoProvider);

    return Drawer(
      width: 310.w,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context, ref),

          SizedBox(height: 16.h),

          // Appearance
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: _buildAppearance(
              context: context,
              ref: ref,
              selectedTheme: selectedTheme,
              borderColor: borderColor,
            ),
          ),

          SizedBox(height: 22.h),

          _sectionTitle(
            'POLICIES & LEGAL',
            colors.onSurfaceVariant,
          ),

          SizedBox(height: 8.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  DrawerMenuItem(
                    icon: Icons.description_rounded,
                    title: 'Terms & Conditions',
                    subtitle: 'Read our terms and conditions',
                    color: const Color(0xFFE76B2F),
                    onTap: () => _navigate(
                      context,
                      RouteNames.termsConditionName,
                    ),
                  ),

                  _divider(borderColor),

                  DrawerMenuItem(
                    icon: Icons.shield_rounded,
                    title: 'Privacy Policy',
                    subtitle: 'How we collect and use your data',
                    color: const Color(0xFF2377F2),
                    onTap: () => _navigate(
                      context,
                      RouteNames.privacyPolicyName,
                    ),
                  ),

                  _divider(borderColor),

                  DrawerMenuItem(
                    icon: Icons.sync_rounded,
                    title: 'Refund Policy',
                    subtitle: 'Our refund and cancellation policy',
                    color: const Color(0xFF199B65),
                    onTap: () => _navigate(
                      context,
                      RouteNames.refundPolicyName,
                    ),
                  ),

                  _divider(borderColor),

                  DrawerMenuItem(
                    icon: Icons.card_giftcard_rounded,
                    title: 'Rewards & Referral Policy',
                    subtitle: 'Learn about rewards and referrals',
                    color: const Color(0xFFD79A16),
                    onTap: () => _navigate(
                      context,
                      RouteNames.rewardReferralPolicyName,
                    ),
                  ),

                  _divider(borderColor),

                  DrawerMenuItem(
                    icon: Icons.receipt_long_rounded,
                    title: 'Subscriptions Policy',
                    subtitle: 'Details about subscription plans',
                    color: const Color(0xFF6549E8),
                    onTap: () => _navigate(
                      context,
                      RouteNames.subscriptionPolicyName,
                    ),
                  ),

                  _divider(borderColor),

                  DrawerMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'FAQ',
                    subtitle: 'Frequently asked questions',
                    color: const Color(0xFF10A5DE),
                    onTap: () => _navigate(
                      context,
                      RouteNames.faqName,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 22.h),

          _sectionTitle(
            'ABOUT',
            colors.onSurfaceVariant,
          ),

          SizedBox(height: 8.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: borderColor),
              ),
              child: DrawerMenuItem(
                icon: Icons.info_rounded,
                title: 'About Us',
                subtitle: packageInfoAsync.when(
                  data: (info) => 'Version T${info.version}',
                  loading: () => 'Loading version...',
                  error: (_, __) => 'Version unavailable',
                ),
                color: const Color(0xFF70839D),
                onTap: () =>  _navigate(
                  context,
                  RouteNames.aboutUsName,
                ),
              ),
            ),
          ),

          if(isLoggedIn)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: DrawerMenuItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              subtitle: 'Sign out from your account',
              color: Colors.red,
              onTap: () => _logout(context, ref),
            ),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Future<void> _logout(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final localStorage = ref.read(localStorageProvider);

    // Check Never Show Again preference
    final neverShowAgain =
    localStorage.getNeverShowLogoutConfirmation();

    if (!neverShowAgain) {
      final confirmed = await _showLogoutConfirmation(
        context: context,
        onNeverShowAgain: () async {
          await localStorage.setNeverShowLogoutConfirmation(true);
        },
      );

      if (!confirmed || !context.mounted) return;
    }

    try {
      // Call Logout Provider
      await ref.read(logoutProvider.notifier).logout();

      if (!context.mounted) return;

      // Refresh current user state
      ref.invalidate(currentUserProvider);

      // Navigate to Login
      context.goNamed(RouteNames.signInName);

    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }


  Future<bool> _showLogoutConfirmation({
    required BuildContext context,
    required Future<void> Function() onNeverShowAgain,
  }) async {
    bool neverShowAgain = false;

    final dark =
        Theme.of(context).brightness == Brightness.dark;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Logout'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Are you sure you want to logout from your account?',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: neverShowAgain,
                        onChanged: (value) {
                          setDialogState(() {
                            neverShowAgain = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text('Never show this again'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dark
                                ? AppColors.blue
                                : Colors.grey.shade400,
                            foregroundColor: dark
                                ? AppColors.white
                                : AppColors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: dark
                                ? AppColors.white
                                : AppColors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          onPressed: () async {
                            if (neverShowAgain) {
                              await onNeverShowAgain();
                            }

                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext, true);
                            }
                          },
                          child: const Text('Logout'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    return result ?? false;
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserProvider);
    final firstName = user?['first_name']?.toString() ?? '';
    final lastName = user?['last_name']?.toString() ?? '';
    final uid = user?['uid']?.toString() ?? '';

    final fullName = '$firstName $lastName'.trim();

    final isLoggedIn = user != null && uid.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18.w,
        16.h,
        6.w,
        22.h,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.drawerHeaderBg),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26.r),
          bottomRight: Radius.circular(26.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          SizedBox(height: 25.h),

          Text(
            'Welcome to Terminal1',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 10.h),


          Row(
            children: [
              Container(
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.75),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 38.sp,
                  color: Colors.white,
                ),
              ),

              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(isLoggedIn)
                    Text(
                      (fullName.isNotEmpty ? fullName : 'User'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    if (isLoggedIn)
                      Text(
                        'UID: $uid',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    else
                      TextButton(
                        onPressed:(){
                          context.pushNamed(RouteNames.signInName);
                        } ,
                        child: Text(
                        'Please Login',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        )
                      ),

                  ],
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppearance({
    required BuildContext context,
    required WidgetRef ref,
    required AppThemeType selectedTheme,
    required Color borderColor,
  }) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(17.r),
      onTap: () => _showAppearanceSheet(context, ref),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 14.h,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(17.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 45.w,
              height: 45.w,
              decoration: BoxDecoration(
                color: const Color(0xFF4935C7),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(
                Icons.wb_sunny_rounded,
                color: Colors.white,
                size: 26.sp,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Light / Dark / System theme',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              _themeLabel(selectedTheme),
              style: TextStyle(
                color: primaryBlue,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showAppearanceSheet(
      BuildContext context,
      WidgetRef ref,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20.w,
              20.h,
              20.w,
              16.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(sheetContext)
                        .colorScheme
                        .onSurface,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Choose how the app looks.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Theme.of(sheetContext)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),

                SizedBox(height: 12.h),

                ...AppThemeType.values.map((option) {
                  final selected =
                      ref.read(themeProvider) == option;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _themeIcon(option),
                      color: primaryBlue,
                    ),
                    title: Text(_themeLabel(option)),
                    trailing: selected
                        ? const Icon(
                      Icons.check_circle_rounded,
                      color: primaryBlue,
                    )
                        : null,
                    onTap: () async {
                      await ref
                          .read(themeProvider.notifier)
                          .setTheme(option);

                      if (sheetContext.mounted) {
                        Navigator.pop(sheetContext);
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _divider(Color color) {
    return Padding(
      padding: EdgeInsets.only(left: 67.w),
      child: Divider(
        height: 1,
        thickness: 0.6,
        color: color,
      ),
    );
  }

  void _navigate(BuildContext context, String routeName) {
    Navigator.pop(context);
    context.pushNamed(routeName);
  }

  String _themeLabel(AppThemeType theme) {
    return switch (theme) {
      AppThemeType.light => 'Light',
      AppThemeType.dark => 'Dark',
      AppThemeType.system => 'System',
    };
  }

  IconData _themeIcon(AppThemeType theme) {
    return switch (theme) {
      AppThemeType.light => Icons.light_mode_rounded,
      AppThemeType.dark => Icons.dark_mode_rounded,
      AppThemeType.system => Icons.settings_suggest_rounded,
    };
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This section will be connected next.'),
      ),
    );
  }
}
