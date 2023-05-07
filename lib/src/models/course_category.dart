import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CourseCategory extends Equatable {
  final String id;
  final String title;
  final String description;

  const CourseCategory({this.id = '', this.title = '', this.description = ''});

  @override
  List<Object?> get props => [id, title, description];

  static CourseCategory fromSnapshot(DocumentSnapshot snap) {
    CourseCategory category = CourseCategory(
        id: snap['id'], title: snap['title'], description: snap['description']);
    return category;
  }
}
