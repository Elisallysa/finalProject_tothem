import 'package:equatable/equatable.dart';
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/models/user.dart';

class CourseDetailsState extends Equatable {
  final Course course;
  final List<Content> contents;
  final List<Task> tasks;
  final List<User> students;

  const CourseDetailsState(
      {required this.course,
      required this.contents,
      required this.tasks,
      required this.students});
  @override
  List<Object?> get props => [course, contents, tasks, students];
}

class InitStates extends CourseDetailsState {
  const InitStates()
      : super(
            course: const Course(),
            contents: const <Content>[],
            tasks: const <Task>[],
            students: const <User>[]);
}

class CourseError extends CourseDetailsState {
  final String error;

  const CourseError({
    required super.course,
    required super.contents,
    required super.tasks,
    required this.error,
    required super.students,
  });

  @override
  List<Object?> get props => [error];
}

class CourseLoaded extends CourseDetailsState {
  const CourseLoaded({
    required Course course,
    required List<Content> contents,
    required List<Task> tasks,
    required List<User> students,
  }) : super(
            course: course,
            contents: contents,
            tasks: tasks,
            students: students);
}
