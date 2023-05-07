import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';
import 'base_reg_courses_repository.dart';

class RegCoursesRepository extends BaseRegCoursesRepository {
  final FirebaseFirestore _firebaseFirestore;

  RegCoursesRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Course>> getAllCategories() {
    return _firebaseFirestore
        .collection('registered_courses')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Course.fromSnapshot(doc)).toList();
    });
  }
}
