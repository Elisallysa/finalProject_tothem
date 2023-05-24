class Content {
  final String id;
  final int index;
  final String title;
  final String description;
  final List<String> attachments;

  const Content(
      {this.id = '',
      this.index = 0,
      this.title = '',
      this.description = '',
      this.attachments = const <String>[]});

  Content copyWith(
      {String? id,
      int? index,
      String? title,
      String? description,
      List<String>? attachments}) {
    return Content(
        id: id ?? this.id,
        index: index ?? this.index,
        title: title ?? this.title,
        description: description ?? this.description,
        attachments: attachments ?? this.attachments);
  }
}
