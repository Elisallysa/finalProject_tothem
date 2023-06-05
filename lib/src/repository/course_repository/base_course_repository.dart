import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tothem/src/models/user.dart';

import '../../models/course.dart';

abstract class BaseCourseRepository {
  // CREATE METHODS

  // READ METHODS
  Stream<List<Course>> getAllCourses();
  Future<List<Course>> getRegCourses(String studentUid);
  Stream<List<Course>> getTeacherCourses(String mail);
  Stream<List<Course>> getRegisteredCourses(String userId);
  Future<Course?> getCourse(String documentId);
  Future<List<User>> getStudents(String courseId);

  // UPDATE METHODS

  // DELETE METHODS
  Future<void> createCourse(Course course, auth.User user);
}
