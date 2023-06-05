import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/repository/content_repository/base_content_repository.dart';

class ContentRepository extends BaseContentRepository {
  final FirebaseFirestore _firebaseFirestore;

  ContentRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Content>> getCourseContents(String courseId) async {
    List<Content> courseContents = <Content>[];

    final QuerySnapshot<Map<String, dynamic>> contentsQuery =
        await _firebaseFirestore.collection('courses/$courseId/contents').get();

    final contents = contentsQuery.docs
        .map((content) => Content.fromSnapshot(content))
        .toList();

    courseContents = contents;
/*
    for (var content in courseContents) {
      for (var task in content.tasks) {
        final taskDoc = await _firebaseFirestore
            .collection('courses/$courseId/tasks')
            .doc(task.id);

        taskDoc.get().then(
          (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;

            Task _emptyTask =
                content.tasks.firstWhere((element) => element.id == task.id);
            _emptyTask = Task.fromSnapshot(data);
          },
          onError: (e) => print("Error getting document: $e"),
        );
      }
      courseContents.add(content);
    }

    return courseContents;
  */

    List<Content> updatedContents =
        []; // Lista temporal para almacenar los contenidos actualizados

    for (var content in courseContents) {
      Content updatedContent = Content.copy(
          courseContents.firstWhere((element) => element.id == content.id));
      List<Task> updatedTasks = <Task>[];

      for (var task in content.tasks) {
        final taskDoc = await _firebaseFirestore
            .collection('courses/$courseId/tasks')
            .doc(task.id)
            .get();

        if (taskDoc.exists) {
          final data = taskDoc.data() as Map<String, dynamic>;
          Task updatedTask = Task.fromMap(data);
/*
          updatedContent.tasks.removeWhere((element) =>
              element.id == task.id); // Eliminar el antiguo objeto Task
          updatedContent.tasks
              .add(updatedTask); // Agregar el objeto Task actualizado
              */

          updatedTasks.add(updatedTask);
        }
      }
      updatedContent.tasks.clear();
      updatedContent.tasks.addAll(updatedTasks);

      updatedContents.add(
          updatedContent); // Agregar el contenido actualizado a la lista temporal
    }

    return updatedContents;

    /*

    // Lista de tareas futuras
    final List<Future<void>> taskFutures = [];

    for (var content in courseContents) {
      for (var task in content.tasks) {
        final taskDoc = _firebaseFirestore
            .collection('courses/$courseId/tasks')
            .doc(task.id);

        final taskFuture = taskDoc.get().then((DocumentSnapshot doc) {
          Task _emptyTask =
              content.tasks.firstWhere((element) => element.id == task.id);
          _emptyTask = Task.fromSnapshot(doc);
        }, onError: (e) => print("Error getting document: $e"));

        taskFutures.add(taskFuture);
      }
    }

    // Esperar a que todas las tareas futuras se completen
    await Future.wait(taskFutures);

    return courseContents;*/
  }
}
