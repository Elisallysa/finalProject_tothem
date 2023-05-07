import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController {
  late FirebaseAuth _auth;
  final _user = Rxn<User>();
  late Stream<User?> _authStateChanges;

  AuthController();

  void initAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    _auth = FirebaseAuth.instance;
    _authStateChanges = _auth.authStateChanges();

    _authStateChanges.listen((User? user) {
      _user.value = user;
      print("...user id ${user?.uid}...");
    });
  }

  User? getUser() {
    _user.value = _auth.currentUser;
    print(_user.value == null ? 'no USER....' : _user.value!.email);
    return _user.value;
  }

  Future<void> signInWithGoogle() async {}
}
