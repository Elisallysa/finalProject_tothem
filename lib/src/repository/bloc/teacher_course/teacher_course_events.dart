import 'package:equatable/equatable.dart';
import 'package:tothem/src/repository/bloc/bloc.dart';

class TeacherCourseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTeacherCourses extends TeacherCourseEvent {}

class UpdateTeacherCourses extends TeacherCourseEvent {
  final List<Course> courses;

  UpdateTeacherCourses(this.courses);

  @override
  List<Object?> get props => [courses];
}

class AddTeacherCourse extends TeacherCourseEvent {}
