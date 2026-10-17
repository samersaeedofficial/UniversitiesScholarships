class DocumentItem {
  final String id;
  final String title;
  bool isCompleted;

  DocumentItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  DocumentItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return DocumentItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
      };

  factory DocumentItem.fromJson(Map<String, dynamic> json) => DocumentItem(
        id: json['id'] as String,
        title: json['title'] as String,
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}
