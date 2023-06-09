import 'package:equatable/equatable.dart';
import 'package:tothem/src/repository/bloc/bloc.dart';

class TeacherCourseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTeacherCourses extends TeacherCourseEvent {}

class UpdateTeacherCourses extends TeacherCourseEvent {
  final List<Course> courses;
  final Map<String, String> categories;

  UpdateTeacherCourses(this.courses, this.categories);

  @override
  List<Object?> get props => [courses, categories];
}

class AddTeacherCourse extends TeacherCourseEvent {}
