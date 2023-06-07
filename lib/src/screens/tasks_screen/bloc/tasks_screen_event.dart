import 'package:equatable/equatable.dart';
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/models/user.dart';

class TasksScreenEvent extends Equatable {
  const TasksScreenEvent();

  @override
  List<Object?> get props => [];
}

class CourseLoading extends TasksScreenEvent {
  final Course course;
  const CourseLoading(this.course);
}

class CourseInfoLoaded extends TasksScreenEvent {
  final Course loadedCourse;
  final List<Content> contents;
  final List<Task> tasks;

  const CourseInfoLoaded(this.loadedCourse, this.contents, this.tasks);

  @override
  List<Object?> get props => [loadedCourse, contents, tasks];
}

class AllStudentTasksLoaded extends TasksScreenEvent {
  final List<Course> loadedCourses;
  final List<Content> contents;
  final List<Task> tasks;

  const AllStudentTasksLoaded(this.loadedCourses, this.contents, this.tasks);

  @override
  List<Object?> get props => [loadedCourses, contents, tasks];
}

class CheckboxChangedEvent extends TasksScreenEvent {
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
