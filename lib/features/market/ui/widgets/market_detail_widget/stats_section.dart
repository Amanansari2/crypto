import 'package:flutter/cupertino.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/helpers/formatters.dart';
import 'info_row.dart';

class StatsSection extends StatelessWidget {
  final dynamic data;

  const StatsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow(label: "High", value: FormatHelper.price(data.high)),
        InfoRow(label: "Low", value: FormatHelper.price(data.low)),
        InfoRow(label: "Volume", value: FormatHelper.compact(data.volume)),
        InfoRow(
          label: "Bid",
          value: FormatHelper.price(data.bid),
          valueColor: AppColors.green,
        ),
        InfoRow(
          label: "Ask",
          value: FormatHelper.price(data.ask),
          valueColor: AppColors.red,
        ),
      ],
    );
  }
}
