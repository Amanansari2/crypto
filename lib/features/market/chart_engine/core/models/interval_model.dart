class IntervalModel {

  final String label;

  final String value;

  final bool isCustom;

  const IntervalModel({

    required this.label,

    required this.value,

    this.isCustom = false,
  });

  Map<String, dynamic> toJson(){
    return {
      'label': label,
      'value': value,
      'isCustom': isCustom,
    };
  }

  factory IntervalModel.fromJson(Map<String, dynamic>json){
    return IntervalModel(
        label: json['label'] as String,
        value: json['value'] as String,
        isCustom: json['isCustom'] as bool? ?? false
    );
  }
}