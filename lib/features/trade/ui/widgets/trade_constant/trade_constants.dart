
class TradeConstants {
  static const triggerPriceTypes = [
    'Market Order',
    'Limit Order',
  ];

  static const triggerOrderTypes = [
    'Last Price',
    'Mark Price',
    'Index Price',
  ];

  static const advancedOrderTypes = [
    'Post Only',
    'Fill Or Kill (FOK)',
    'Immediate Or Cancel (IOC)',
  ];

  static const orderTypes = [
    'Limit',
    'Market',
    'Advanced Limit',
    'Trigger',
    'Scaled Order',
  ];

  static const bboTypes = [
    'Counterparty 1',
    'Counterparty 5',
    'Queue 1',
    'Queue 5',
  ];

  static const distributionType = [
    'Equal',
    'Increasing',
    'Decreasing',
    'Random',
  ];
}