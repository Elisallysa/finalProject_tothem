import 'package:tothem/src/models/course.dart';

import '../../models/course_category.dart';

abstract class BaseRegCoursesRepository {
  Stream<List<Course>> getAllCategories();
}
