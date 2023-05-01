import '../../models/user.dart';

abstract class BaseUserRepository {
  Stream<List<User>> getAllCategories();
}
