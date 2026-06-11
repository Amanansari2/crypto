class EmaDataModel {

  final Map<int, List<double?>> values;

  const EmaDataModel({
    required this.values,
  });

  List<double?>? getPeriod(
      int period,
      ) {

    return values[period];
  }
}