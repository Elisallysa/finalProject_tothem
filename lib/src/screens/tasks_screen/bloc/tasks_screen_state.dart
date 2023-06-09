import 'package:equatable/equatable.dart';
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';

class TasksScreenState extends Equatable {
  final Course course;
  final List<Content> contents;
  final List<Task> tasks;

  const TasksScreenState(
      {required this.course, required this.contents, required this.tasks});
  @override
  List<Object?> get props => [course, contents, tasks];
}

class InitStates extends TasksScreenState {
  const InitStates()
      : super(
            course: const Course(),
            contents: const <Content>[],
            tasks: const <Task>[]);
}

class CourseError extends TasksScreenState {
  final String error;

  const CourseError(
      {required super.course,
      required super.contents,
      required super.tasks,
      required this.error});

  @override
  List<Object?> get props => [error];
}

class CourseLoaded extends TasksScreenState {
  const CourseLoaded(
      {required Course course,
      required List<Content> contents,
      required List<Task> tasks})
      : super(course: course, contents: contents, tasks: tasks);
}

class AllTasksLoaded extends TasksScreenState {
  final List<Course> coursesAndTasks;

  const AllTasksLoaded({required this.coursesAndTasks})
      : super(
            course: const Course(),
            contents: const <Content>[],
            tasks: const <Task>[]);
}
