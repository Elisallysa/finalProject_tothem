import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/course.dart';

abstract class BaseContentRepository {
  // CREATE METHODS

  // READ METHODS
  Future<List<Content>> getCourseContents(String courseId);

  // UPDATE METHODS

  // DELETE METHODS
}
