class TodoModel {
  final String id;
  final String title;
  final String description;
  final List<String> tags;

  TodoModel(
      {this.id,
      this.title,
      this.description = '',
      this.tags = const <String>[]});

  TodoModel.update(TodoModel target,
      {String id, String title, String description, List<String> tags})
      : id = id ?? target.id,
        title = title ?? target.title,
        description = description ?? target.description,
        tags = tags ?? target.tags;

  TodoModel.merge(TodoModel target, TodoModel source)
      : id = source.id ?? target.id,
        title = source.title ?? target.title,
        description = source.description ?? target.description,
        tags = source.tags ?? target.tags;

  TodoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        title = json['title'] ?? '',
        description = json['description'] ?? '',
        tags = List.castFrom<dynamic, String>(json['tags']) ?? <String>[];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tags': tags,
    };
  }

  @override
  toString() {
    return '$title, $description, $tags';
  }
}
