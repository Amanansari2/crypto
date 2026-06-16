import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/indicators/boll_setting_sheet.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/indicators/ema_setting_sheet.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/indicators/kdj_setting_sheet.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/indicators/macd_setting_sheet.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/indicators/obv_setting_sheet.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/indicators/roc_setting_sheet.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/indicators/rsi_setting_sheet.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/settings/indicators/volume_setting_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'indicators/ma_setting_sheet.dart';
import 'indicators/wr_setting_sheet.dart';


class IndicatorSettingsSheet extends StatelessWidget {
  const IndicatorSettingsSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Indicators Setting',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [



          _SectionTitle(
            title: 'Main Indicators',
          ),

          _IndicatorTile(
            title: 'MA',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const MaSettingSheet(),
              );
            },
          ),

          _IndicatorTile(
            title: 'EMA',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const EmaSettingSheet(),
              );
            },
          ),

          _IndicatorTile(
            title: 'BOLL',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const BollSettingSheet(),
              );
            },
          ),

          const SizedBox(height: 10),

          Divider(
            height: 1,
            color: Colors.grey.withOpacity(.2),
          ),

          const SizedBox(height: 10),

          _SectionTitle(
            title: 'Sub Indicators',
          ),

          _IndicatorTile(
            title: 'VOL',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const VolumeSettingSheet(),
              );
            },
          ),

          _IndicatorTile(
            title: 'MACD',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const MacdSettingsSheet(),
              );
            },
          ),

          _IndicatorTile(
            title: 'KDJ',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const KdjSettingSheet(),
              );
            },
          ),

          _IndicatorTile(
            title: 'RSI',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const RsiSettingsSheet(),
              );
            },
          ),

          _IndicatorTile(
            title: 'ROC',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const RocSettingSheet(),
              );
            },
          ),

          _IndicatorTile(
            title: 'WR',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const WrSettingSheet(),
              );
            },
          ),

          _IndicatorTile(
            title: 'OBV',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const ObvSettingSheet(),
              );
            },
          ),

          _IndicatorTile(
            title: 'StochRSI',
            onTap: () {},
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Align(
        alignment:
        Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _IndicatorTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _IndicatorTile({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        child: Row(
          children: [

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),

            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}