class MaDataModel {

  final Map<int, List<double?>> values;

  const MaDataModel({
    required this.values,
  });

  List<double?>? getPeriod(
      int period,
      ) {

    return values[period];
  }
}