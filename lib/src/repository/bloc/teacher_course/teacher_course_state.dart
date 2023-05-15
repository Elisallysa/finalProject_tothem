import 'package:equatable/equatable.dart';

import '../../../models/course.dart';

class TeacherCourseState extends Equatable {
  const TeacherCourseState();

  @override
  List<Object?> get props => [];
}

class InitStates extends TeacherCourseState {
  const InitStates() : super();
}

class TeacherCourseLoading extends TeacherCourseState {}

class TeacherCourseLoaded extends TeacherCourseState {
  final List<Course> courses;

  const TeacherCourseLoaded({this.courses = const <Course>[]});

  @override
  List<Object?> get props => [courses];
}
