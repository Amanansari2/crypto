class RsiDataModel {

  final Map<int, List<double?>> values;

  const RsiDataModel({
    required this.values,
  });

  List<double?>? getPeriod(
      int period
      ) {
    return values[period];
  }
}