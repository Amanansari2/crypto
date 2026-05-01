import 'package:intl/intl.dart';

class FormatHelper {
  FormatHelper._();

  static final _priceFormatter = NumberFormat("#,##0.00", "en_US");

  /// 💰 PRICE (2 decimal)
  static String price(double value) {
    return _priceFormatter.format(value);
  }

  /// 📊 PERCENT (+ / -)
  static String percent(double value) {
    final isUp = value >= 0;
    return "${isUp ? '+' : '-'}${value.toStringAsFixed(2)}%";
  }

  /// 🔢 COMPACT NUMBER (K / M / B)
  static String compact(double value) {
    if (value >= 1e9) {
      return "${(value / 1e9).toStringAsFixed(2)} B";
    } else if (value >= 1e6) {
      return "${(value / 1e6).toStringAsFixed(2)} M";
    } else if (value >= 1e3) {
      return "${(value / 1e3).toStringAsFixed(2)} K";
    } else {
      return value.toStringAsFixed(2);
    }
  }

  /// 📉 SIMPLE NUMBER (no format)
  static String number(double value) {
    return value.toStringAsFixed(2);
  }
}