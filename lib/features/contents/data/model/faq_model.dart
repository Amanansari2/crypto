
class FaqResponseModel {
  final bool success;
  final FaqModel data;

  FaqResponseModel({
    required this.success,
    required this.data,
  });

  factory FaqResponseModel.fromJson(Map<String, dynamic> json) {
    return FaqResponseModel(
      success: json['success'] as bool? ?? false,
      data: FaqModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      ),
    );
  }
}

class FaqModel {
  final int id;
  final String slug;
  final String title;
  final String description;
  final String status;
  final List<FaqCategoryModel> categories;

  FaqModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.status,
    required this.categories,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] as int? ?? 0,
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? '',
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map(
            (item) => FaqCategoryModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
    );
  }
}

class FaqCategoryModel {
  final int id;
  final String category;
  final List<FaqQuestionModel> questions;

  FaqCategoryModel({
    required this.id,
    required this.category,
    required this.questions,
  });

  factory FaqCategoryModel.fromJson(Map<String, dynamic> json) {
    return FaqCategoryModel(
      id: json['id'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map(
            (item) => FaqQuestionModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
    );
  }
}

class FaqQuestionModel {
  final int id;
  final String question;
  final String answer;

  FaqQuestionModel({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory FaqQuestionModel.fromJson(Map<String, dynamic> json) {
    return FaqQuestionModel(
      id: json['id'] as int? ?? 0,
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
    );
  }
}
