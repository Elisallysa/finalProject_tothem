import 'dart:convert';
import 'package:tothem/src/models/user.dart';

class Course {
  final String? id;
  final String title;
  final String areaOfKnowledge;
  final int trainingHours;
  final String teacherId;
  final List<User> students;

  const Course(
      {this.id,
      this.title = '',
      this.areaOfKnowledge = '',
      this.trainingHours = 0,
      this.teacherId = '',
      this.students = const []});

  Course copyWith({
    String? id,
    String? title,
    String? areaOfKnowledge,
    int? trainingHours,
    String? teacherId,
    List<User>? students,
  }) {
    return Course(
        id: id ?? this.id,
        title: title ?? this.title,
        areaOfKnowledge: areaOfKnowledge ?? this.areaOfKnowledge,
        trainingHours: trainingHours ?? this.trainingHours,
        teacherId: teacherId ?? this.teacherId,
        students: students ?? this.students);
  }

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["course_id"],
        title: json["title"],
        areaOfKnowledge: json["areaOfKnowledge"],
        students:
            List<User>.from(json["studentList"].map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "areaOfKnowledge": areaOfKnowledge,
        "studentList": List<dynamic>.from(students.map((x) => x.toJson())),
      };
}

// Método de serialización de string de json a lista de cursos
List<Course> courseFromJson(String str) =>
    List<Course>.from(json.decode(str).map((x) => Course.fromJson(x)));

// Método de serialización de lista de cursos a cadena de caracteres
String courseToJson(List<Course> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
