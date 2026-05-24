import '../constants/chart_config.dart';

class ViewportEngine {

  /// 🔥 max scroll
  static double calculateMaxScroll({

    required int totalCandles,

    required double candleWidth,

    required double screenWidth,
  }) {

    return (

        (
            totalCandles +

                ChartConfig
                    .rightSideExtraCandles
        )

            * candleWidth

    ) - screenWidth;
  }

  /// 🔥 latest detection
  static bool isAtLatest({

    required double scrollX,

    required double maxScroll,

    required double candleWidth,
  }) {

    return (

        maxScroll - scrollX

    ) < (

        candleWidth * 3
    );
  }
}