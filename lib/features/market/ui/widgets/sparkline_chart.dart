import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';

class SparklineChart extends StatelessWidget {
  final List<double> data;
  final bool isPositive;
  final double change;

  const SparklineChart({
    super.key,
    required this.data,
    required this.isPositive,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox();
    }

    final spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);

    final adjustedMinY = minY == maxY ? minY - 1 : minY;
    final adjustedMaxY = minY == maxY ? maxY + 1 : maxY;

    final baseColor = isPositive ? AppColors.green : AppColors.red;

    return SizedBox(
      height: 40.h,
      child: LineChart(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        LineChartData(
          minY: adjustedMinY,
          maxY: adjustedMaxY,
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),

          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,

            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(color: Colors.white.withOpacity(0.3), strokeWidth: 1),
                  FlDotData(
                    getDotPainter: (spot, percent, bar, index) {
                      return FlDotCirclePainter(
                        radius: 3.r,
                        color: baseColor,
                        strokeWidth: 1.5,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                );
              }).toList();
            },

            touchTooltipData: LineTouchTooltipData(
              tooltipBorderRadius: BorderRadius.circular(10.r),
              tooltipPadding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 6.h,
              ),
              tooltipMargin: 30.h,
              getTooltipColor: (_) => Colors.black.withOpacity(0.85),
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  return LineTooltipItem(
                    "\$${spot.y.toStringAsFixed(2)}\n${change.toStringAsFixed(2)}%",
                    TextStyle(
                      color: AppColors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.25,
              gradient: LinearGradient(
                colors: [
                  baseColor.withOpacity(0.9),
                  baseColor.withOpacity(0.5),
                ],
              ),
              barWidth: 1.8.w,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) {
                  if (index == spots.length - 1) {
                    return FlDotCirclePainter(
                      radius: 2.5.r,
                      color: baseColor,
                      strokeWidth: 1,
                      strokeColor: Colors.white,
                    );
                  }
                  return FlDotCirclePainter(radius: 0.r);
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [baseColor.withOpacity(0.25), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
