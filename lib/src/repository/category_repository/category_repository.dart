import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course_category.dart';
import 'base_category_repository.dart';

class CategoryRepository extends BaseCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  CategoryRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<CourseCategory>> getAllCategories() {
    return _firebaseFirestore
        .collection('course_category')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CourseCategory.fromSnapshot(doc))
          .toList();
    });
  }
}
