import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:tothem/src/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class Course extends Equatable {
  final String? id;
  final String title;
  final String code;
  final String category;
  final int trainingHours;
  final String teacher;
  final String description;
  final List<User> students;
  final DateTime? createDate;
  final DateTime? registerDate;

  const Course(
      {this.id = '',
      this.title = '',
      this.code = '',
      this.category = '',
      this.trainingHours = 0,
      this.teacher = '',
      this.description = '',
      this.students = const <User>[],
      this.createDate = const ConstDateTime(0),
      this.registerDate = const ConstDateTime(0)});

  Course copyWith({
    String? id,
    String? title,
    String? code,
    String? category,
    int? trainingHours,
    String? teacher,
    String? description,
    List<User>? students,
    DateTime? createDate,
    DateTime? registerDate,
  }) {
    return Course(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        category: category ?? this.category,
        trainingHours: trainingHours ?? this.trainingHours,
        teacher: teacher ?? this.teacher,
        description: description ?? this.description,
        students: students ?? this.students,
        createDate: createDate ?? this.createDate,
        registerDate: registerDate ?? this.registerDate);
  }

  factory Course.fromJson(Map<String, dynamic> json) => Course(
      id: json['course_id'],
      category: json['category'],
      title: json['title'],
      teacher: json['teacher_name'],
      description: json['description']);

  Map<String, dynamic> toJson() => {
        "title": title,
        "category": category,
        "description": description,
        "create_date": createDate
        //"studentList": List<dynamic>.from(students.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [title, category];

  static Course fromSnapshot(DocumentSnapshot snap) {
    Timestamp createDate = snap['create_date'];

    Course course = Course(
        title: snap['title'],
        category: snap['category'],
        id: snap.id,
        description: snap['description'],
        createDate: createDate.toDate());

    return course;
  }
}

// Método de serialización de string de json a lista de cursos
List<Course> courseFromJson(String str) =>
    List<Course>.from(json.decode(str).map((x) => Course.fromJson(x)));

// Método de serialización de lista de cursos a cadena de caracteres
String courseToJson(List<Course> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
