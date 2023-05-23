import 'package:tothem/src/models/course.dart';

class CourseDetailsEvent {
  const CourseDetailsEvent();
}

class CourseLoading extends CourseDetailsEvent {
  final Course course;
  CourseLoading(this.course);
}

class CourseInfoLoaded extends CourseDetailsEvent {
  Course loadedCourse;
  CourseInfoLoaded(this.loadedCourse);
}
