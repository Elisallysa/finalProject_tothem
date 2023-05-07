import '../../models/course_category.dart';

abstract class BaseCategoryRepository {
  Stream<List<CourseCategory>> getAllCategories();
}
