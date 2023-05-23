import 'package:equatable/equatable.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';

class CourseDetailsState extends Equatable {
  const CourseDetailsState();

  @override
  List<Object?> get props => [];
}

class InitStates extends CourseDetailsState {
  const InitStates() : super();
}

class CourseError extends CourseDetailsState {
  final String error;
  const CourseError(this.error);
}

class CourseLoaded extends CourseDetailsState {
  final Course course;
  final List<Task> tasks;

  const CourseLoaded(this.course, this.tasks);
  @override
  List<Object?> get props => [course, tasks];
}
