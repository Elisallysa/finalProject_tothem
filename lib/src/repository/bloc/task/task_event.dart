import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';

class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class TaskLoading extends TaskEvent {
  final Course course;
  final Task task;
  final String currentUserUid;
  const TaskLoading(this.course, this.task, this.currentUserUid);
}

class TaskInfoLoaded extends TaskEvent {
  final Course course;
  final Task task;
  final Future<storage.ListResult>? listResults;

  const TaskInfoLoaded(this.course, this.task, this.listResults);

  @override
  List<Object?> get props => [course, task, listResults];
}

class UpdateTask extends TaskEvent {
  final Course course;
  final Task task;
  const UpdateTask(this.course, this.task);

  @override
  List<Object?> get props => [course, task];
}

class TaskDone extends TaskEvent {
  final Course course;
  final Task task;
  final String userId;
  const TaskDone(this.course, this.task, this.userId);
  @override
  List<Object?> get props => [course, task, userId];
}
