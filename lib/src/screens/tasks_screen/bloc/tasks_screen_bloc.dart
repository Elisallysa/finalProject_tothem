import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/repository/auth_repository/auth_repository.dart';
import 'package:tothem/src/repository/content_repository/content_repository.dart';
import 'package:tothem/src/repository/course_repository/course_repository.dart';
import 'package:tothem/src/repository/task_repository/task_repository.dart';
import 'package:tothem/src/screens/tasks_screen/bloc/tasks_screen_event.dart';
import 'package:tothem/src/screens/tasks_screen/bloc/tasks_screen_state.dart';

class TasksScreenBloc extends Bloc<TasksScreenEvent, TasksScreenState> {
  final CourseRepository _courseRepository;
  final ContentRepository _contentRepository;
  final TaskRepository _taskRepository;
  final AuthRepository _authRepository;

  TasksScreenBloc(
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

    on<AllStudentTasksLoaded>(
        (event, emit) => _updateTasksToState(event, emit));
  }

  Future<void> _loadCourseToState(
      Emitter<TasksScreenState> emit, Course? course) async {
    auth.User? user = _authRepository.getUser();
    if (user != null) {
      try {
        if (course != null) {
          Course? loadedCourse = await _courseRepository.getCourse(course.id!);
          List<Content> courseContents = [];
          List<Task> courseTasks = [];

          if (loadedCourse != null) {
            courseContents =
                await _contentRepository.getCourseContents(loadedCourse.id!);

            courseTasks =
                await _taskRepository.getCourseTasks(loadedCourse.id!);

            add(CourseInfoLoaded(loadedCourse, courseContents, courseTasks));
          } else {
            emit(const CourseError(<Course>[],
                course: Course(),
                contents: <Content>[],
                tasks: <Task>[],
                error:
                    'No se ha podido encontrar el curso. Por favor, vuelve a iniciar la aplicación.'));
          }
        } else {
          List<Course> userCoursesAndTasks =
              await _taskRepository.getAllUserRegCourses();
          state.coursesAndTasks.clear;
          add(AllStudentTasksLoaded(userCoursesAndTasks));
        }
      } catch (error) {
        emit(CourseError(const <Course>[],
            course: const Course(),
            contents: const <Content>[],
            tasks: const <Task>[],
            error: 'Error cargando el curso: $error'));
      }
    } else {
      print('-----USUARIO NULO------');
    }
  }

  Future<void> _mapCheckboxChangedToState(
      CheckboxChangedEvent event, Emitter<TasksScreenState> emit) async {
    try {
      final updatedContents = state.contents.map((content) {
        final updatedTasks = content.tasks.map((task) {
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
          tasks: updatedTasks,
        );

        return updatedContent;
      }).toList();
      // Llamar al método en CourseRepository para actualizar el documento en Firestore
      Task? updatedTask = await _taskRepository.updateTaskStatus(
        event.courseId,
        event.taskId,
        event.isChecked,
      );

      if (state is CourseLoaded) {
        List<Task> updatedTasksList = [];
        updatedTasksList.addAll(state.tasks);
        if (updatedTask != null) {
          updatedTasksList
              .removeWhere((element) => element.id == updatedTask.id);
          updatedTasksList.add(updatedTask);
        }

        emit(CourseLoaded(
            course: state.course,
            contents: updatedContents,
            tasks: updatedTasksList));
      } else if (state is AllTasksLoaded) {
        List<Course> updatedUserCoursesAndTasks =
            await _taskRepository.getAllUserRegCourses();
        state.coursesAndTasks.clear;
        emit(state.reset());
        add(AllStudentTasksLoaded(updatedUserCoursesAndTasks));
      }

/*
      List<Task> updatedTasks = [];
      updatedTasks.addAll(state.tasks);
      if (updatedTask != null) {
        updatedTasks.removeWhere((element) => element.id == updatedTask.id);
        updatedTasks.add(updatedTask);
      }

      if (state is CourseLoaded) {
        emit(CourseLoaded(
            course: state.course,
            contents: updatedContents,
            tasks: updatedTasks));
      } else {
        List<Course> updatedCoursesAndTasks = [];
        updatedCoursesAndTasks.addAll(state.coursesAndTasks);

        Course courseToBeUpdated = updatedCoursesAndTasks
            .firstWhere((element) => element.id == updatedTask!.courseRef);

        Task taskToReplace = courseToBeUpdated.tasks
            .firstWhere((tsk) => tsk.id == updatedTask!.id);
        Task newTask = taskToReplace.copyWith(done: updatedTask!.done);
        courseToBeUpdated.tasks.remove(taskToReplace);
        courseToBeUpdated.tasks.add(newTask);

        List<Task> updatedTasks = [];
        updatedTasks.addAll(courseToBeUpdated.tasks);

        Course updatedCourse = courseToBeUpdated.copyWith(tasks: updatedTasks);

        updatedCoursesAndTasks.remove(courseToBeUpdated);
        updatedCoursesAndTasks.add(updatedCourse);

        emit(AllTasksLoaded(coursesAndTasks: updatedCoursesAndTasks));
        
         }
        */
    } catch (error) {
      print('Error checking task done.');
      emit(CourseLoaded(
          course: state.course, contents: state.contents, tasks: state.tasks));
    }
  }

  _updateCourseToState(CourseInfoLoaded event, Emitter<TasksScreenState> emit) {
    emit(CourseLoaded(
        course: event.loadedCourse,
        contents: event.contents,
        tasks: event.tasks));
  }

  _updateTasksToState(
      AllStudentTasksLoaded event, Emitter<TasksScreenState> emit) {
    emit(AllTasksLoaded(coursesAndTasks: event.loadedCoursesAndTasks));
  }
}
