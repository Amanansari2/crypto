class MacdDataModel {

  final List<double?> macd;

  final List<double?> signal;

  final List<double?> histogram;

  const MacdDataModel({
    required this.macd,
    required this.signal,
    required this.histogram,
  });
}