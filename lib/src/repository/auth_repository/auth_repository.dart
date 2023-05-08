import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tothem/src/models/user.dart' as tothemUser;
import 'package:tothem/src/repository/auth_repository/base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  auth.User? getUser() {
    auth.User? user = auth.FirebaseAuth.instance.currentUser;
    print(user == null ? 'no USER....' : user.email);
    return user;
  }

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();
}
