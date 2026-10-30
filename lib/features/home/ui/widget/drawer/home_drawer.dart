
import 'package:crypto_app/app/router/route_names.dart';
import 'package:crypto_app/core/theme/theme_provider.dart';
import 'package:crypto_app/core/utils/enums/app_theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../core/utils/constants/app_images.dart';
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
          _buildHeader(context),

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

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20.w,
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

          Row(
            children: [
              Container(
                width: 65.w,
                height: 65.w,
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
                    Text(
                      'Your Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 9.h),

                    OutlinedButton.icon(
                      onPressed: () => _showComingSoon(context),
                      icon: Icon(
                        Icons.person_outline_rounded,
                        size: 15.sp,
                      ),
                      label: const Text('Update Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.65),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        textStyle: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
