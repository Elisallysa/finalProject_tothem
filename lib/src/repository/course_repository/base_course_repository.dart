import '../../models/course.dart';

abstract class BaseCourseRepository {
  Stream<List<Course>> getAllCourses();
}
