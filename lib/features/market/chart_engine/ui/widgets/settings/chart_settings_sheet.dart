import 'package:crypto_app/app/router/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/constants/app_colors.dart';

class ChartSettingsSheet extends StatelessWidget {
  const ChartSettingsSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark? AppColors.darkBg : AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            18,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Chart Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              Expanded(
                child: _SettingTile(
                  icon: CupertinoIcons.chart_bar_circle,
                  title: 'Indicators',
                  onTap: () {
                    Navigator.pop(context);
                    context.pushNamed(RouteNames.customIndicatorName);
                  },
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: _SettingTile(
                  icon: CupertinoIcons.device_phone_landscape,
                  title: 'Landscape',
                  onTap: () {},
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: _SettingTile(
                  icon: CupertinoIcons.pencil_outline,
                  title: 'Drawings',
                  onTap: () {},
                ),
              ),
            ],
          ),



          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: dark
              ? AppColors.blue.withOpacity(0.08)
              : AppColors.white,

          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: dark
                ? AppColors.blue.withOpacity(0.4)
                : Colors.grey.withOpacity(0.4),
          ),
          boxShadow: dark
              ? []
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              size: 16,
              color: Colors.grey,
            ),

            const SizedBox(width: 6),

            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}