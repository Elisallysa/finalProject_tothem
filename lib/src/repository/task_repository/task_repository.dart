import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/repository/task_repository/base_task_repository.dart';

class TaskRepository extends BaseTaskRepository {
  final FirebaseFirestore _firebaseFirestore;

  TaskRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Task>> getContentTasks(String contentId) {
    // TODO: implement getContentTasks
    throw UnimplementedError();
  }

  Future<Task?> getTaskInfo(String courseId, String taskId) async {
    final DocumentSnapshot snapshot = await _firebaseFirestore
        .collection('courses/$courseId/tasks')
        .doc(taskId)
        .get();

    if (snapshot.exists) {
      final Task task = Task.fromSnapshot(snapshot);
      return task;
    }
    return null;
  }

  @override
  Future<List<Task>> getCourseTasks(String courseId) async {
    final QuerySnapshot<Map<String, dynamic>> tasksQuery =
        await _firebaseFirestore.collection('courses/$courseId/tasks').get();

    final courseTasks =
        tasksQuery.docs.map((tsk) => Task.fromSnapshot(tsk)).toList();

    return courseTasks;
  }

  Future<Task?> updateTaskStatus(
    String courseId,
    String taskId,
    bool isChecked,
  ) async {
    try {
      // Obtener la referencia al documento del task en Firestore
      final taskRef =
          _firebaseFirestore.collection('courses/$courseId/tasks').doc(taskId);

      // Actualizar el campo "done" del documento del task
      await taskRef.update({
        'done': isChecked,
      });

      // Obtener el task actualizado desde Firestore
      final taskSnapshot = await taskRef.get();
      final taskData = taskSnapshot.data() as Map<String, dynamic>;

      // Construir y devolver el objeto Task actualizado
      return Task.fromMap(taskData);
    } catch (error) {
      print('Task status could not be updated.');
      return null;
    }
  }

/*
  Future<Task?> updateTask(
   Task updatedTask
  ) async {
    try {
      // Obtener la referencia al documento del task en Firestore
      final taskRef =
          _firebaseFirestore.collection('courses/$courseId/tasks').doc(taskId);

      // Actualizar el campo "done" del documento del task
      await taskRef.update({
        'done': isChecked,
      });

      // Obtener el task actualizado desde Firestore
      final taskSnapshot = await taskRef.get();
      final taskData = taskSnapshot.data() as Map<String, dynamic>;

      // Construir y devolver el objeto Task actualizado
      return Task.fromMap(taskData);
    } catch (error) {
      print('Task status could not be updated.');
      return null;
    }
  }
  */
}
