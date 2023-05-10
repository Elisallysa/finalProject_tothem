import 'package:firebase_auth/firebase_auth.dart';

import '../../models/course.dart';

abstract class BaseCourseRepository {
  Stream<List<Course>> getAllCourses();
  Future<List<Course>> getRegCourses(String studentUid);
  Future<void> createCourse(Course course, User user);
}
