import 'package:equatable/equatable.dart';
import 'package:tothem/src/repository/bloc/bloc.dart';

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
  final Map<String, String> categories;

  const TeacherCourseLoaded(
      {this.courses = const <Course>[], this.categories = const {}});

  @override
  List<Object?> get props => [courses];
}
