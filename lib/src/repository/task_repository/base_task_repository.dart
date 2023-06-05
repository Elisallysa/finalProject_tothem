import 'package:tothem/src/models/task.dart';

abstract class BaseTaskRepository {
  // CREATE METHODS

  // READ METHODS
  Future<List<Task>> getCourseTasks(String courseId);
  Future<List<Task>> getContentTasks(String contentId);

  // UPDATE METHODS

  // DELETE METHODS
}
