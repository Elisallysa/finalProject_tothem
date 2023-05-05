import 'package:equatable/equatable.dart';

import '../../../models/course.dart';

class CourseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCourses extends CourseEvent {}

class UpdateCourses extends CourseEvent {
  final List<Course> courses;

  UpdateCourses(this.courses);

  @override
  List<Object?> get props => [courses];
}
