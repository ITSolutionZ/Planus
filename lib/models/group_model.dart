enum Category {
  studing,
  reading,
}

class Group {
  final int id;
  final String name;
  final String description;
  final Category category;
  final int members;
  final String imageUrl;
  List<String> hashtags;
  List<String> joinmembers;
  bool isFullmember;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.members,
    required this.imageUrl,
    this.hashtags = const [],
    this.joinmembers = const [],
  }) : isFullmember = joinmembers.length >= members;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.name,
      'members': members,
      'imageUrl': imageUrl,
      'hashtags': hashtags,
      'joinmembers': joinmembers,
      'isFullmember': isFullmember,
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Group',
      description: json['description'] ?? '',
      category: Category.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => Category.reading,
      ),
      members: json['members'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      hashtags: List<String>.from(json['hashtags'] ?? []),
      joinmembers: List<String>.from(json['joinmembers'] ?? []),
    );
  }

  @override
  String toString() {
    return 'Group(id: $id, name: $name, description: $description, category: $category, '
        'members: $members, imageUrl: $imageUrl, hashtags: $hashtags, '
        'joinmembers: $joinmembers, isFullmember: $isFullmember)';
  }
}
