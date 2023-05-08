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
        .doc(studentUid)
        .get();

    final data = querySnapshot.data();

    if (data != null && data.isNotEmpty) {
      final List<List<dynamic>> coursesData = data['courses'];
      int index = 0;
      final List<Course> courses = coursesData.map((courseData) {
        final courseInfo = courseData[index];
        return Course(title: courseInfo['title']);
      }).toList();

      return courses;
    } else {
      return <Course>[];
    }
  }
}
