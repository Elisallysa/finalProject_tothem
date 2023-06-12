import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/repository/bloc/course/course_state.dart';
import 'package:tothem/src/repository/task_repository/base_task_repository.dart';
import 'package:tothem/src/screens/screens.dart';

class TaskRepository extends BaseTaskRepository {
  final FirebaseFirestore _firebaseFirestore;
  final AuthRepository _authRepository = AuthRepository();

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
      final Task task = Task.fromSnapshot(snapshot, courseId);
      return task;
    }
    return null;
  }

  @override
  Future<List<Task>> getCourseTasks(String courseId) async {
    final QuerySnapshot<Map<String, dynamic>> tasksQuery =
        await _firebaseFirestore.collection('courses/$courseId/tasks').get();

    final courseTasks =
        tasksQuery.docs.map((tsk) => Task.fromSnapshot(tsk, courseId)).toList();

    return courseTasks;
  }

  Future<Task?> updateTaskStatus(
    String courseId,
    String taskId,
    bool isChecked,
  ) async {
    auth.User? currentUser = _authRepository.getUser();

    try {
      if (currentUser != null) {
        // Obtener la referencia al documento del task en Firestore
        final taskRef = _firebaseFirestore
            .collection(
                'registered_courses/${currentUser.uid}_reg_courses/tasks')
            .doc(courseId);
// Verificar si existe el documento
        final taskSnapshot = await taskRef.get();

        if (taskSnapshot.exists) {
          final courseData = taskSnapshot.data() as Map<String, dynamic>;

// Verificar si el mapa con taskId existe en el documento
          if (courseData.containsKey(taskId)) {
            final taskData = courseData[taskId] as Map<String, dynamic>;
            taskData['done'] = isChecked;

            await taskRef.update({taskId: taskData});
          } else {
            final newTaskData = {'done': isChecked, "id": taskId};

            await taskRef.set({taskId: newTaskData}, SetOptions(merge: true));
          }
        } else {
          final newTaskData = {'done': isChecked, "id": taskId};

          await taskRef.set({taskId: newTaskData}, SetOptions(merge: true));
        }

/*
        
        if (taskSnapshot.exists) {
          // Actualizar el campo "done" del documento existente
          await taskRef.update({
            'done': isChecked,
          });
        } else {
          // Crear un nuevo documento con el estado de la tarea
          await taskRef.set({'done': isChecked, 'id': taskId});
        }
*/

        // Obtener el task actualizado desde Firestore
        final updatedTaskSnapshot = await taskRef.get();
        final uTaskData = updatedTaskSnapshot.data() as Map<String, dynamic>;

        // Construir y devolver el objeto Task actualizado
        return Task.fromSimpleMap(uTaskData[taskId]);
      } else {
        throw 'User is not logged in. Log in again.';
      }
    } catch (error) {
      print('Task status could not be updated.');
      return null;
    }
  }

  /// Gets all user's registered courses tasks from Firestore.
  Future<List<Course>> getAllUserRegCourses() async {
    auth.User? currentUser = _authRepository.getUser();

    List<Course> userRegCourses = [];
    List<Course> userRegCoursesAndTasks = [];
    // First: get list of user's registered courses
    if (currentUser != null) {
      final querySnapshot = await _firebaseFirestore
          .collection('registered_courses')
          .where(FieldPath.documentId,
              isEqualTo: '${currentUser.uid}_reg_courses')
          .get();

      // Second: map each document to object Course
      for (var doc in querySnapshot.docs) {
        int courseNumber = 1;
        while (doc.data().containsKey('course$courseNumber')) {
          final course = Course.fromJson(doc.data()['course$courseNumber']);
          userRegCourses.add(course);
          courseNumber++;
        }
      }

      // Get user's registered courses task lists to get task status
      final regCoursesTasksQuery = await _firebaseFirestore
          .collection('registered_courses')
          .doc('${currentUser.uid}_reg_courses')
          .collection('tasks')
          .get();

      final regCoursesTasks = regCoursesTasksQuery.docs;

      // Gets courses' task lists
      if (userRegCourses.isNotEmpty) {
        // Goes through the list of courses the user is registered in
        for (var course in userRegCourses) {
          // Gets list of tasks of courses in userRegCourses
          final QuerySnapshot<Map<String, dynamic>> tasksQuery =
              await _firebaseFirestore
                  .collection('courses/${course.id}/tasks')
                  .get();

          final courseTasks = tasksQuery.docs
              .map((task) => Task.fromSnapshot(task, course.id!))
              .toList();

          List<Task> regTasksStatus = [];

          // Checks whether the tasks of the registered courses are completed...
          // and updates the status of tasks in a new List<Task>
          for (var doc in regCoursesTasks) {
            if (doc.id == course.id) {
              for (var key in doc.data().keys) {
                final task = Task.fromSimpleJson(doc.data()[key]);

                Task taskAndStatus = Task.copy(
                    courseTasks.firstWhere((element) => element.id == task.id));
                taskAndStatus = taskAndStatus.copyWith(done: task.done);

                regTasksStatus.add(taskAndStatus);
              }
            }
          }
          // ...and adds new updated List<Task> to the Course and then add
          // it to a List<Course> of updated Course
          Course courseTasksAndStatus = course.copyWith(tasks: regTasksStatus);
          userRegCoursesAndTasks.add(courseTasksAndStatus);
        }

        return userRegCoursesAndTasks;
      }
    }
    return userRegCoursesAndTasks;
  }

  /// Gets all user's registered courses tasks from Firestore.
  Future<List<Course>> getAllUserTaskRefs() async {
    auth.User? currentUser = _authRepository.getUser();

    List<Course> userRegCourses = [];
    List<Course> userRegCoursesAndTasks = [];

    // First: get list of user's registered courses
    if (currentUser != null) {
      final querySnapshot = await _firebaseFirestore
          .collection('registered_courses')
          .where(FieldPath.documentId,
              isEqualTo: '${currentUser.uid}_reg_courses')
          .get();

      // Second: map each document to object Course
      for (var doc in querySnapshot.docs) {
        int courseNumber = 1;
        while (doc.data().containsKey('course$courseNumber')) {
          final course = Course.fromJson(doc.data()['course$courseNumber']);
          userRegCourses.add(course);
          courseNumber++;
        }
      }

      // Get user's registered courses task lists to get task status
      final regCoursesTasksQuery = await _firebaseFirestore
          .collection('registered_courses')
          .doc('${currentUser.uid}_reg_courses')
          .collection('tasks')
          .get();

      final regCourses = regCoursesTasksQuery.docs;

      // Get courses' task lists
      if (userRegCourses.isNotEmpty) {
        for (var course in userRegCourses) {
          final QuerySnapshot<Map<String, dynamic>> tasksQuery =
              await _firebaseFirestore
                  .collection('courses/${course.id}/tasks')
                  .get();

          final courseTasks = tasksQuery.docs
              .map((task) => Task.fromSnapshot(task, course.id!))
              .toList();

          List<Task> regTasksStatus = [];

          //PROBAR ESTO!!!!!!!!!!!!!!! -----------------------
          for (var doc in regCourses) {
            if (doc.id == course.id) {
              for (var key in doc.data().keys) {
                final task = Task.fromSimpleJson(doc.data()[key]);

                Task taskAndStatus = Task.copy(
                    courseTasks.firstWhere((element) => element.id == task.id));
                taskAndStatus = taskAndStatus.copyWith(done: task.done);

                regTasksStatus.add(taskAndStatus);

                Course courseTaskAndStatus =
                    course.copyWith(tasks: regTasksStatus);

                userRegCoursesAndTasks.add(courseTaskAndStatus);
              }
            }
          }
/*
          List<Task> courseTasksReferenced = [];

          for (var tsk in courseTasks) {
            bool status = regCoursesTasks
                .firstWhere((regTask) => regTask.id == tsk.id)
                .done;
            Task tskAndRef = tsk.copyWith(courseRef: course.id, done: status);
            courseTasksReferenced.add(tskAndRef);
          }

          Course courseAndTasks = course.copyWith(tasks: courseTasksReferenced);

          
          */
        }
      }
    }
    return userRegCoursesAndTasks;
  }

  Future<void> editCourseTaskList(
      Task newTask, String contentId, Course course) async {
    // If newTask id is empty, that means a new task needs to be written
    if (newTask.id.isEmpty) {
      final courseRef = _firebaseFirestore.collection('courses').doc(course.id);
      final contentRef = courseRef.collection('contents').doc(contentId);

      final contentSnapshot = await contentRef.get();

      if (contentSnapshot.exists) {
        final contentData = contentSnapshot.data();

        int lastTaskNumber = 0;
        int contentNumber = 0;

// Get content number
        RegExp regex = RegExp(r'\d+$');
        Match? matchContent = regex.firstMatch(contentId);

        if (matchContent != null) {
          String strContentNumber = matchContent.group(0)!;
          contentNumber = int.parse(strContentNumber);
        }

        if (contentData != null && contentData.containsKey('tasks')) {
          // El documento de la subcolección "contents" tiene un atributo "tasks" que es un mapa
          List<String> tasksMap = contentData['tasks'];
          String lastKey = tasksMap.last;

          // Gets last registered course

          Match? match = regex.firstMatch(lastKey);

          // Gets last content task id number
          if (match != null) {
            String numberString = match.group(0)!;
            lastTaskNumber = int.parse(numberString);
          }
        } else {
          String newTaskName = 'c${(contentNumber)}t${(lastTaskNumber + 1)}';
          Task taskToWrite = newTask.copyWith(id: newTaskName);

          try {
            await courseRef
                .collection('tasks')
                .doc(newTaskName)
                .set(taskToWrite.toJson())
                .onError((e, _) => print(
                    "Error writing task data to \"tasks\" subcollection in course ${course.id} in \"courses\" collection: $e"));

            /*
            await contentRef.update({
              FieldPath(const ['tasks']): FieldValue.arrayUnion([newTaskName]),
            });
            */

            contentRef.update({
              "tasks": FieldValue.arrayUnion([newTaskName]),
            });
          } catch (e) {
            print('Error setting task data in "courses" collection: $e');
          }
        }
      } else {
        // El documento de la subcolección "contents" no existe
      }
    }
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
