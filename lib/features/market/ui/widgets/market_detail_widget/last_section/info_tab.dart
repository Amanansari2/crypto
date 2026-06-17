import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/binance/contract_info_provider.dart';

class InfoTab extends ConsumerWidget {
  final String symbol;

  const InfoTab({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final infoAsync = ref.watch(
      contractInfoProvider(symbol),
    );

    return infoAsync.when(

      loading: () =>
      const Center(
        child:
        CircularProgressIndicator(),
      ),

      error: (e, _) =>
          Center(
            child: Text(
              e.toString(),
            ),
          ),

      data: (data) {

        return SingleChildScrollView(
          padding:
          const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              const Text(
                "Contract Info",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              _infoRow(
                "Settlement crypto",
                data.settlementCrypto,
              ),

              _infoRow(
                "Tick size",
                data.tickSize,
              ),

              _infoRow(
                "Leverage",
                data.leverage,
              ),

              _infoRow(
                "Funding fee settled",
                data.fundingFeeSettled,
              ),

              _infoRow(
                "Maximum Order Size (Limit)",
                data.maxLimitOrderSize,
              ),

              _infoRow(
                "Maximum Order Size (Market)",
                data.maxMarketOrderSize,
              ),

              _infoRow(
                "Base Asset",
                data.baseAsset,
              ),

              _infoRow(
                "Quote Asset",
                data.quoteAsset,
              ),

              _infoRow(
                "Contract Type",
                data.contractType,
              ),

              if (data.fundingRate != null)
                _infoRow(
                  "Funding Rate",
                  data.fundingRate!,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(
      String title,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        children: [

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}