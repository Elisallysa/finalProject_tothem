import 'package:equatable/equatable.dart';
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';

class TasksScreenState extends Equatable {
  final Course course;
  final List<Content> contents;
  final List<Task> tasks;
  final List<Course> coursesAndTasks;

  const TasksScreenState(this.coursesAndTasks,
      {required this.course, required this.contents, required this.tasks});

  @override
  List<Object?> get props => [course, contents, tasks, coursesAndTasks];

  // Método para restablecer los atributos a su estado inicial
  TasksScreenState reset() {
    return const TasksScreenState(<Course>[],
        course: Course(), contents: <Content>[], tasks: <Task>[]);
  }
}

class InitStates extends TasksScreenState {
  const InitStates()
      : super(
          const <Course>[],
          course: const Course(),
          contents: const <Content>[],
          tasks: const <Task>[],
        );
}

class CourseError extends TasksScreenState {
  final String error;

  const CourseError(super.coursesAndTasks,
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
      : super(const <Course>[],
            course: course, contents: contents, tasks: tasks);
}

class AllTasksLoaded extends TasksScreenState {
  const AllTasksLoaded({required List<Course> coursesAndTasks})
      : super(coursesAndTasks,
            course: const Course(),
            contents: const <Content>[],
            tasks: const <Task>[]);
}
