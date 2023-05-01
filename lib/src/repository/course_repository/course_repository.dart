import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tothem/src/repository/course_repository/base_course_repository.dart';

import '../../models/course.dart';

class CourseRepository extends BaseCourseRepository {
  final FirebaseFirestore _firebaseFirestore;

  CourseRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Course>> getAllCategories() {
    return _firebaseFirestore.collection('courses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Course.fromSnapshot(doc)).toList();
    });
  }
}
