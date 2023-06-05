import 'package:equatable/equatable.dart';
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/models/user.dart';

class CourseDetailsEvent extends Equatable {
  const CourseDetailsEvent();

  @override
  List<Object?> get props => [];
}

class CourseLoading extends CourseDetailsEvent {
  final Course course;
  const CourseLoading(this.course);
}

class CourseInfoLoaded extends CourseDetailsEvent {
  final Course loadedCourse;
  final List<Content> contents;
  final List<Task> tasks;
  final List<User> students;

  const CourseInfoLoaded(
      this.loadedCourse, this.contents, this.tasks, this.students);

  @override
  List<Object?> get props => [loadedCourse, contents, tasks];
}

class CheckboxChangedEvent extends CourseDetailsEvent {
  final String courseId;
  final String taskId;
  final bool isChecked;

  const CheckboxChangedEvent({
    required this.courseId,
    required this.taskId,
    required this.isChecked,
  });

  @override
  List<Object?> get props => [courseId, taskId, isChecked];
}
