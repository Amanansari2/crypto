
import 'package:crypto_app/app/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crypto_app/core/theme/theme_provider.dart';
import 'package:crypto_app/core/utils/enums/app_theme_type.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const Color primaryBlue = Color(0xFF0878FF);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;
    final secondaryText = isDark
        ? const Color(0xFF91A2BA)
        : const Color(0xFF68778F);
    final borderColor = isDark
        ? const Color(0xFF1D3046)
        : const Color(0xFFE1E8F2);

    final selectedTheme = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Gradient header and profile.
          _buildProfileHeader(context),

          SizedBox(height: 14.h),

          // Appearance.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: _buildAppearanceCard(
              context: context,
              ref: ref,
              isDark: isDark,
              surface: surface,
              textColor: textColor,
              secondaryText: secondaryText,
              borderColor: borderColor,
              selectedTheme: selectedTheme,
            ),
          ),

          SizedBox(height: 22.h),

          _sectionTitle(
            'POLICIES & LEGAL',
            secondaryText,
          ),

          SizedBox(height: 8.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _policyTile(
                    icon: Icons.description_rounded,
                    title: 'Terms & Conditions',
                    subtitle: 'Read our terms and conditions',
                    color: const Color(0xFFE76B2F),
                    textColor: textColor,
                    secondaryText: secondaryText,
                    onTap: (){
                      context.pushNamed(RouteNames.termsConditionName);
                    },
                  ),
                  _divider(borderColor),
                  _policyTile(
                    icon: Icons.shield_rounded,
                    title: 'Privacy Policy',
                    subtitle: 'How we collect and use your data',
                    color: const Color(0xFF2377F2),
                    textColor: textColor,
                    secondaryText: secondaryText,
                    onTap: () {
                      context.pushNamed(RouteNames.privacyPolicyName,);
                    }
                  ),
                  _divider(borderColor),
                  _policyTile(
                    icon: Icons.sync_rounded,
                    title: 'Refund Policy',
                    subtitle: 'Our refund and cancellation policy',
                    color: const Color(0xFF199B65),
                    textColor: textColor,
                    secondaryText: secondaryText,
                    onTap: (){
                      context.pushNamed(RouteNames.refundPolicyName);
                    }
                  ),
                  _divider(borderColor),
                  _policyTile(
                    icon: Icons.card_giftcard_rounded,
                    title: 'Rewards & Referral Policy',
                    subtitle: 'Learn about rewards and referrals',
                    color: const Color(0xFFD79A16),
                    textColor: textColor,
                    secondaryText: secondaryText,
                    onTap: () {
                      context.pushNamed(RouteNames.rewardReferralPolicyName);
                    },
                  ),
                  _divider(borderColor),
                  _policyTile(
                    icon: Icons.receipt_long_rounded,
                    title: 'Subscriptions',
                    subtitle: 'Details about subscription plans',
                    color: const Color(0xFF6549E8),
                    textColor: textColor,
                    secondaryText: secondaryText,
                    onTap: () {
                      context.pushNamed(RouteNames.subscriptionPolicyName);
                    },
                  ),
                  _divider(borderColor),
                  _policyTile(
                    icon: Icons.help_outline_rounded,
                    title: 'FAQ',
                    subtitle: 'Frequently asked questions',
                    color: const Color(0xFF10A5DE),
                    textColor: textColor,
                    secondaryText: secondaryText,
                    onTap: () {
                      context.pushNamed(RouteNames.faqName);
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 22.h),

          _sectionTitle('ABOUT', secondaryText),

          SizedBox(height: 8.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: borderColor),
              ),
              child: _policyTile(
                icon: Icons.info_rounded,
                title: 'About App',
                subtitle: 'Version 1.0.0',
                color: const Color(0xFF70839D),
                textColor: textColor,
                secondaryText: secondaryText,
                onTap: () => _showComingSoon(context),
                showDivider: false,
              ),
            ),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w,  MediaQuery.of(context).padding.top, 20.w, 18.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0647D9),
            Color(0xFF087EFF),
            Color(0xFF102D78),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26.r),
          bottomRight: Radius.circular(26.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.18),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.75),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 43.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    OutlinedButton.icon(
                      onPressed: () => _showComingSoon(context),
                      icon: Icon(
                        Icons.person_outline_rounded,
                        size: 16.sp,
                      ),
                      label: const Text('Update Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.65),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
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

  Widget _buildAppearanceCard({
    required BuildContext context,
    required WidgetRef ref,
    required bool isDark,
    required Color surface,
    required Color textColor,
    required Color secondaryText,
    required Color borderColor,
    required AppThemeType selectedTheme,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(17.r),
      onTap: () => _showAppearanceSheet(context, ref),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 14.h,
        ),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(17.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFF4935C7),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(
                Icons.wb_sunny_rounded,
                color: Colors.white,
                size: 27.sp,
              ),
            ),
            SizedBox(width: 13.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Light / Dark / System theme',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11.sp,
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
            SizedBox(width: 3.w),
            Icon(
              Icons.chevron_right_rounded,
              color: secondaryText,
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
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
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
                  final selected = ref.read(themeProvider) == option;

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

  Widget _policyTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    required Color secondaryText,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 11.h,
        ),
        child: Row(
          children: [
            Container(
              width: 43.w,
              height: 43.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 23.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: secondaryText,
              size: 23.sp,
            ),
          ],
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
