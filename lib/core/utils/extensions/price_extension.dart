import 'package:crypto_app/core/utils/constants/app_strings.dart';

import '../enums/price_type.dart';

extension PriceTypeX on PriceType {
  String get label {
    switch (this) {
      case PriceType.last:
        return AppStrings.lastPrice;
      case PriceType.indexPrice:
        return AppStrings.indexPrice;
      case PriceType.mark:
        return AppStrings.markPrice;
    }
  }
}
