import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tothem/src/models/user.dart';

class Comment {
  final String id;
  final String content;
  final DateTime? posted;
  final User? user;

  const Comment({this.id = '', this.content = '', this.posted, this.user});

  Comment copyWith({
    String? id,
    String? content,
    DateTime? posted,
    User? user,
  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      posted: posted ?? this.posted,
      user: user ?? this.user,
    );
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    Timestamp posted = json['posted'];

    Comment cmmt = Comment(
      id: json["id"] ?? '',
      content: json["content"],
      posted: posted.toDate(),
      // user
    );
    return cmmt;
  }
}
