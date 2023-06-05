import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/repository/auth_repository/auth_repository.dart';
import 'package:tothem/src/repository/bloc/task/task_event.dart';
import 'package:tothem/src/repository/bloc/task/task_state.dart';
import 'package:tothem/src/repository/course_repository/course_repository.dart';
import 'package:tothem/src/repository/task_repository/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CourseRepository _courseRepository;
  final AuthRepository _authRepository;
  final TaskRepository _taskRepository;

  TaskBloc(
      {required AuthRepository authRepository,
      required CourseRepository courseRepository,
      required TaskRepository taskRepository})
      : _authRepository = authRepository,
        _courseRepository = courseRepository,
        _taskRepository = taskRepository,
        super(const InitStates()) {
    on<TaskLoading>((event, emit) async {
      await _loadTaskToState(
          emit, event.course, event.task, event.currentUserUid);
    });
    on<TaskDone>((event, emit) async {
      await _taskDone(event, event.userId, emit);
    });
  }

  Future<void> _loadTaskToState(
      Emitter<TaskState> emit, Course course, Task task, String userId) async {
    try {
      Task? taskInfo = await _taskRepository.getTaskInfo(course.id!, task.id);

      List<storage.Reference> taskFiles = <storage.Reference>[];

      if (taskInfo != null) {
        if (taskInfo.attachments.isNotEmpty) {
          storage.ListResult listResult =
              await storage.FirebaseStorage.instance.ref('/$userId').listAll();

          List<storage.Reference> files = listResult.items;

          // Perform operations with the list of files
          for (storage.Reference fileRef in files) {
            // Obtain information about the file, such as name and URL

            String fileName = fileRef.name;

            if (taskInfo.attachments.contains(fileName)) {
              // Perform necessary operations with the file information
              String fileUrl = await fileRef.getDownloadURL();
              taskFiles.add(fileRef);
              print('File Name: $fileName');
              print('File URL: $fileUrl');
            }
          }
        }

        emit(
            TaskLoaded(course: course, task: taskInfo, attachments: taskFiles));
      } else {
        emit(TaskError(
            error: 'No se ha encontrado la tarea.',
            course: state.course,
            task: state.task,
            attachments: state.attachments));
      }
    } catch (error) {
      emit(TaskError(
          error: 'Error cargando la tarea: $error',
          course: state.course,
          task: state.task,
          attachments: state.attachments));
    }
  }

  Future<void> _taskDone(
      TaskDone event, String userId, Emitter<TaskState> emit) async {
    try {
      // Call a method in TaskRepository to updateTaskStatus
      Task? updatedTask = await _taskRepository.updateTaskStatus(
        event.course.id!,
        event.task.id,
        true,
      );

      if (updatedTask != null) {
        emit(TaskLoaded(
            course: state.course,
            task: updatedTask,
            attachments: state.attachments));
      } else {
        emit(TaskError(
            error: 'No se ha actualizado el estado de la tarea.',
            course: state.course,
            task: state.task,
            attachments: state.attachments));
      }
    } catch (error) {
      print('Error checking task done.');
      emit(TaskError(
          error: 'No se ha actualizado el estado de la tarea.',
          course: state.course,
          task: state.task,
          attachments: state.attachments));
    }
  }
}
