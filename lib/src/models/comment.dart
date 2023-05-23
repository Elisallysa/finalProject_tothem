import 'package:tothem/src/models/user.dart';

class Comment {
  final String id;
  final String content;
  final User? user;

  const Comment({this.id = '', this.content = '', this.user});

  Comment copyWith({
    String? id,
    String? content,
    User? user,
  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      user: user ?? this.user,
    );
  }
}
