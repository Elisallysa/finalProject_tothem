import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user.dart';
import 'base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<User>> getAllCategories() {
    return _firebaseFirestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }
}
