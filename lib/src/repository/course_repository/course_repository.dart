import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tothem/src/repository/course_repository/base_course_repository.dart';

import '../../models/course.dart';

class CourseRepository extends BaseCourseRepository {
  final FirebaseFirestore _firebaseFirestore;

  CourseRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Course>> getAllCourses() {
    return _firebaseFirestore.collection('courses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Course.fromSnapshot(doc)).toList();
    });
  }

  Future<List<Course>> getRegCourses(String studentUid) async {
    final querySnapshot = await _firebaseFirestore
        .collection('registered_courses')
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: studentUid)
        .get();

    final List<Course> courses = [];

    for (var doc in querySnapshot.docs) {
      int courseNumber = 1;
      while (doc.data().containsKey('course$courseNumber')) {
        final course = Course.fromJson(doc.data()['course$courseNumber']);
        courses.add(course);
        courseNumber++;
      }
    }
    return courses;
  }
}
