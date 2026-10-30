class ContentResponseModel {
  final bool success;
  final ContentModel data;

  ContentResponseModel({
    required this.success,
    required this.data,
  });

  factory ContentResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ContentResponseModel(
      success: json['success'] as bool? ?? false,
      data: ContentModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      ),
    );
  }
}

class ContentModel {
  final int id;
  final String slug;
  final String title;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<ContentSectionModel> sections;

  ContentModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.sections,
  });

  factory ContentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ContentModel(
      id: json['id'] as int? ?? 0,
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      sections: (json['sections'] as List<dynamic>? ?? [])
          .map(
            (item) => ContentSectionModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
    );
  }
}

class ContentSectionModel {
  final int id;
  final String? eyebrow;
  final String title;
  final String? iconName;
  final String? flutterIcon;
  final int sectionOrder;
  final List<ContentBlockModel> blocks;

  ContentSectionModel({
    required this.id,
    this.eyebrow,
    required this.title,
    this.iconName,
    this.flutterIcon,
    required this.sectionOrder,
    required this.blocks,
  });

  factory ContentSectionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ContentSectionModel(
      id: json['id'] as int? ?? 0,
      eyebrow: json['eyebrow'] as String?,
      title: json['title'] as String? ?? '',
      iconName: json['icon_name'] as String?,
      flutterIcon: json['flutter_icon'] as String?,
      sectionOrder: json['section_order'] as int? ?? 0,
      blocks: (json['blocks'] as List<dynamic>? ?? [])
          .map(
            (item) => ContentBlockModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList(),
    );
  }
}

class ContentBlockModel {
  final int id;
  final String type;
  final String content;
  final String? iconName;
  final int order;

  ContentBlockModel({
    required this.id,
    required this.type,
    required this.content,
    this.iconName,
    required this.order,
  });

  factory ContentBlockModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ContentBlockModel(
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      content: json['content'] as String? ?? '',
      iconName: json['icon_name'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }
}