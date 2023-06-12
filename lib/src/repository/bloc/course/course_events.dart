import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../../models/course.dart';

class CourseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCourses extends CourseEvent {}

class UpdateCourses extends CourseEvent {
  final List<Course> courses;
  final Map<String, String> categoriesMap;

  UpdateCourses(this.courses, this.categoriesMap);

  @override
  List<Object?> get props => [courses, categoriesMap];
}

class JoinCourse extends CourseEvent {
  final auth.User user;
  final String courseCode;

  JoinCourse({required this.user, required this.courseCode});

  @override
  List<Object> get props => [];
}
