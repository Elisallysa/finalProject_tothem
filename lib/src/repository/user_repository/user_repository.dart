import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user.dart';
import 'base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<String>> getAllUserIds() {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    return usersCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  @override
  Future<void> createUser(User user) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .set(user.toJson());
  }

  @override
  Stream<List<User>> getAllUsers() {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    return usersCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<User> getUser(String uid) {
    print('Getting user data from Cloud Firestore.');
    return _firebaseFirestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Future<void> updateUser(User user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toJson())
        .then((value) => print('User document updated.'));
  }
}
