import 'package:equatable/equatable.dart';

import '../../../models/course.dart';

class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

class InitStates extends CourseState {
  const InitStates() : super();
}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<Course> courses;
  final Map<String, String>? categoriesMap;

  const CourseLoaded(this.categoriesMap, {this.courses = const <Course>[]});

  @override
  List<Object?> get props => [courses];
}
