import '../../models/user.dart';

abstract class BaseUserRepository {
  Stream<List<User>> getAllUsers();
  Stream<List<String>> getAllUserIds();
  Stream<User> getUser(String uid);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
}
