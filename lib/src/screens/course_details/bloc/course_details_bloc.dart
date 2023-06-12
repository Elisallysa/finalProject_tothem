import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/models/user.dart';
import 'package:tothem/src/repository/auth_repository/auth_repository.dart';
import 'package:tothem/src/repository/content_repository/content_repository.dart';
import 'package:tothem/src/repository/course_repository/course_repository.dart';
import 'package:tothem/src/repository/task_repository/task_repository.dart';
import 'package:tothem/src/screens/course_details/bloc/course_details_event.dart';
import 'package:tothem/src/screens/course_details/bloc/course_details_state.dart';

class CourseDetailsBloc extends Bloc<CourseDetailsEvent, CourseDetailsState> {
  final CourseRepository _courseRepository;
  StreamSubscription? _courseSubscription;
  final ContentRepository _contentRepository;
  final TaskRepository _taskRepository;
  final AuthRepository _authRepository;

  CourseDetailsBloc(
      {required AuthRepository authRepository,
      required CourseRepository courseRepository,
      required ContentRepository contentRepository,
      required TaskRepository taskRepository})
      : _authRepository = authRepository,
        _courseRepository = courseRepository,
        _contentRepository = contentRepository,
        _taskRepository = taskRepository,
        super(const InitStates()) {
    on<CourseLoading>((event, emit) async {
      await _loadCourseToState(emit, event.course);
    });

    on<CheckboxChangedEvent>((event, emit) async {
      print('CHECK BOX CHANGED EVENT -----');
      await _mapCheckboxChangedToState(event, emit);
    });

    on<CourseInfoLoaded>((event, emit) => _updateCourseToState(event, emit));
  }

  Future<void> _loadCourseToState(
      Emitter<CourseDetailsState> emit, Course course) async {
    _courseSubscription?.cancel();

    auth.User? user = _authRepository.getUser();
    if (user != null) {
      try {
        Course? loadedCourse = await _courseRepository.getCourse(course.id!);

        if (loadedCourse != null) {
          List<Content> courseContents =
              await _contentRepository.getCourseContents(loadedCourse.id!);

          List<Task> courseTasks =
              await _taskRepository.getCourseTasks(loadedCourse.id!);

          List<User> courseStudents =
              await _courseRepository.getStudents(loadedCourse.id!);

          add(CourseInfoLoaded(
              loadedCourse, courseContents, courseTasks, courseStudents));
        } else {
          emit(const CourseError(
              course: Course(),
              contents: <Content>[],
              tasks: <Task>[],
              students: <User>[],
              error:
                  'No se ha podido encontrar el curso. Por favor, vuelve a iniciar la aplicación.'));
        }
      } catch (error) {
        emit(CourseError(
            course: const Course(),
            contents: const <Content>[],
            tasks: const <Task>[],
            students: const <User>[],
            error: 'Error cargando el curso: $error'));
      }
    } else {
      print('-----USUARIO NULO------');
    }
  }

  Future<void> _updateCourseToState(
      CourseInfoLoaded event, Emitter<CourseDetailsState> emit) async {
    emit(CourseLoaded(
        course: event.loadedCourse,
        contents: event.contents,
        tasks: event.tasks,
        students: event.students));
  }

  Future<void> _mapCheckboxChangedToState(
      CheckboxChangedEvent event, Emitter<CourseDetailsState> emit) async {
    try {
      final updatedContents = state.contents.map((content) {
        final contentTasks = content.tasks.map((task) {
          if (task.id == event.taskId) {
            // Crear una nueva instancia de Task con el estado actualizado
            final updatedTask = Task(
              id: task.id,
              title: task.title,
              description: task.description,
              createDate: task.createDate,
              dueDate: task.dueDate,
              comments: task.comments,
              done: event.isChecked,
            );
            return updatedTask;
          }
          return task;
        }).toList();

        // Crear una nueva instancia de Content con la lista de tasks actualizada
        final updatedContent = Content(
          id: content.id,
          title: content.title,
          description: content.description,
          attachments: content.attachments,
          tasks: contentTasks,
        );

        return updatedContent;
      }).toList();
      // Llamar al método en CourseRepository para actualizar el documento en Firestore
      Task? updatedTask = await _taskRepository.updateTaskStatus(
        event.courseId,
        event.taskId,
        event.isChecked,
      );

      List<Task> updatedTasksList = [];
      updatedTasksList.addAll(state.tasks);
      if (updatedTask != null) {
        updatedTasksList.removeWhere((element) => element.id == updatedTask.id);
        updatedTasksList.add(updatedTask);
      }

      emit(CourseLoaded(
        course: state.course,
        contents: updatedContents,
        tasks: updatedTasksList,
        students: state.students,
      ));
    } catch (error) {
      print('Error checking task done.');
      emit(CourseLoaded(
          course: state.course,
          contents: state.contents,
          tasks: state.tasks,
          students: state.students));
    }
  }
}
