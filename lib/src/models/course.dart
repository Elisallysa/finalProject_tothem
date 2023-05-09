import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tothem/src/models/user.dart';

class Course extends Equatable {
  final String? id;
  final String title;
  final String category;
  final int trainingHours;
  final String teacherId;
  final List<User> students;

  const Course(
      {this.id = '',
      this.title = '',
      this.category = '',
      this.trainingHours = 0,
      this.teacherId = '',
      this.students = const <User>[]});

  Course copyWith({
    String? id,
    String? title,
    String? category,
    int? trainingHours,
    String? teacherId,
    List<User>? students,
  }) {
    return Course(
        id: id ?? this.id,
        title: title ?? this.title,
        category: category ?? this.category,
        trainingHours: trainingHours ?? this.trainingHours,
        teacherId: teacherId ?? this.teacherId,
        students: students ?? this.students);
  }

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['course_id'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category": category,
        "studentList": List<dynamic>.from(students.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [title, category];

  static Course fromSnapshot(DocumentSnapshot snap) {
    Course course = Course(title: snap['title'], category: snap['category']);
    return course;
  }
}

// Método de serialización de string de json a lista de cursos
List<Course> courseFromJson(String str) =>
    List<Course>.from(json.decode(str).map((x) => Course.fromJson(x)));

// Método de serialización de lista de cursos a cadena de caracteres
String courseToJson(List<Course> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
