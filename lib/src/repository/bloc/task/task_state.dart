import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';

class TaskState extends Equatable {
  final Course course;
  final Task task;
  final List<storage.Reference> attachments;

  const TaskState(
      {required this.course, required this.task, required this.attachments});
  @override
  List<Object?> get props => [course, task, attachments];
}

class InitStates extends TaskState {
  const InitStates()
      : super(
            course: const Course(),
            task: const Task(),
            attachments: const <storage.Reference>[]);
}

class TaskLoaded extends TaskState {
  const TaskLoaded(
      {required Course course,
      required Task task,
      required List<storage.Reference> attachments})
      : super(course: course, task: task, attachments: attachments);
}

class TaskError extends TaskState {
  final String error;

  const TaskError({
    required this.error,
    required super.course,
    required super.task,
    required super.attachments,
  });

  @override
  List<Object?> get props => [error];
}
