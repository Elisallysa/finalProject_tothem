import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class Course extends Equatable {
  final String? id;
  final String title;
  final String code;
  final String category;
  final int trainingHours;
  final String imagePath;
  final String teacher;
  final String teacherName;
  final String teacherPhoto;
  final String description;
  final List<User> students;
  final List<Content> contents;
  final List<Task> tasks;
  final DateTime? createDate;
  final DateTime? registerDate;

  const Course(
      {this.id = '',
      this.title = '',
      this.code = '',
      this.category = '',
      this.trainingHours = 0,
      this.imagePath = '',
      this.teacher = '',
      this.teacherName = '',
      this.teacherPhoto = '',
      this.description = '',
      this.students = const <User>[],
      this.contents = const <Content>[],
      this.tasks = const <Task>[],
      this.createDate = const ConstDateTime(0),
      this.registerDate = const ConstDateTime(0)});

  Course copyWith({
    String? id,
    String? title,
    String? code,
    String? category,
    int? trainingHours,
    String? imagePath,
    String? teacher,
    String? teacherName,
    String? teacherPhoto,
    String? description,
    List<User>? students,
    List<Content>? contents,
    List<Task>? tasks,
    DateTime? createDate,
    DateTime? registerDate,
  }) {
    return Course(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        category: category ?? this.category,
        trainingHours: trainingHours ?? this.trainingHours,
        imagePath: imagePath ?? this.imagePath,
        teacher: teacher ?? this.teacher,
        teacherName: teacherName ?? this.teacherName,
        teacherPhoto: teacherPhoto ?? this.teacherPhoto,
        description: description ?? this.description,
        students: students ?? this.students,
        contents: contents ?? this.contents,
        tasks: tasks ?? this.tasks,
        createDate: createDate ?? this.createDate,
        registerDate: registerDate ?? this.registerDate);
  }

  Course.copy(Course other)
      : id = other.id,
        title = other.title,
        code = other.code,
        category = other.category,
        trainingHours = other.trainingHours,
        imagePath = other.imagePath,
        teacher = other.teacher,
        teacherName = other.teacherName,
        teacherPhoto = other.teacherPhoto,
        description = other.description,
        students = other.students,
        contents = other.contents,
        tasks = other.tasks,
        createDate = other.createDate,
        registerDate = other.registerDate;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
      id: json['course_id'],
      category: json['category'],
      title: json['title'],
      teacher: json['teacher'],
      teacherName: json['teacher_name'],
      teacherPhoto: json['teacher_photo'] ?? '',
      description: json['description']);

  Map<String, dynamic> toRegCourseJson() => {
        "title": title,
        "category": category,
        "course_id": id,

        "register_date": Timestamp.fromDate(registerDate!),
        "description": description,
        "teacher": teacher,
        "teacher_name": teacherName,
        "teacher_photo": teacherPhoto

        //"studentList": List<dynamic>.from(students.map((x) => x.toJson())),
      };

  Map<String, dynamic> toJson() => {
        "title": title,
        "category": category,
        "course_id": id,
        "create_date": Timestamp.fromDate(createDate!.toUtc()),
        "description": description,
        "teacher": teacher,
        "teacher_name": teacherName,
        "teacher_photo": teacherPhoto,
        "code": code

        //"studentList": List<dynamic>.from(students.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [title, category];

  static Course fromSnapshot(DocumentSnapshot snap) {
    Timestamp createDate = snap['create_date'];

    String courseCode = '';
    try {
      courseCode = snap['code'];
    } catch (e) {
      print('No course code in Firestore.');
    }

    Course course = Course(
        title: snap['title'],
        code: courseCode,
        teacher: snap['teacher'],
        teacherName: snap['teacher_name'],
        teacherPhoto: snap['teacher_photo'],
        category: snap['category'],
        id: snap.id,
        description: snap['description'],
        createDate: createDate.toDate());

    return course;
  }

  static Course fromCourseSnapshot(DocumentSnapshot snap) {
    Timestamp createDate = snap['create_date'];

    Course course = Course(
        title: snap['title'],
        category: snap['category'],
        teacher: snap['teacher'],
        id: snap.id,
        description: snap['description'],
        createDate: createDate.toDate());

    return course;
  }

  /// Sorts [Course] in descending order by [createDate]
  int compareTo(Course other) {
    return -createDate!.compareTo(other.createDate!);
  }
}

// Método de serialización de string de json a lista de cursos
List<Course> courseFromJson(String str) =>
    List<Course>.from(json.decode(str).map((x) => Course.fromJson(x)));

/*
// Método de serialización de lista de cursos a cadena de caracteres
String courseToJson(List<Course> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
*/