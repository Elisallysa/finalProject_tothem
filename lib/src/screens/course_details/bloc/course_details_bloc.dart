import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/repository/auth_repository/auth_repository.dart';
import 'package:tothem/src/repository/course_repository/course_repository.dart';
import 'package:tothem/src/screens/course_details/bloc/course_details_event.dart';
import 'package:tothem/src/screens/course_details/bloc/course_details_state.dart';

class CourseDetailsBloc extends Bloc<CourseDetailsEvent, CourseDetailsState> {
  final CourseRepository _courseRepository;
  StreamSubscription? _courseSubscription;
  final AuthRepository _authRepository;

  CourseDetailsBloc({
    required AuthRepository authRepository,
    required CourseRepository courseRepository,
  })  : _authRepository = authRepository,
        _courseRepository = courseRepository,
        super(InitStates()) {
    on<CourseLoading>((event, emit) async {
      await _loadCourseToState(emit, event.course);
    });

    on<CourseInfoLoaded>((event, emit) => _updateCourseToState(event, emit));
  }

  Future<void> _loadCourseToState(
      Emitter<CourseDetailsState> emit, Course course) async {
    _courseSubscription?.cancel();

    User? user = _authRepository.getUser();
    if (user != null) {
      try {
        Course? loadedCourse = await _courseRepository.getCourse(course.id!);
        if (loadedCourse != null) {
          add(CourseInfoLoaded(loadedCourse));
        } else {
          emit(const CourseError(
              'No se ha podido encontrar el curso. Por favor, vuelve a iniciar la aplicación.'));
        }
      } catch (error) {
        emit(CourseError('Error cargando el curso: $error'));
      }
    } else {
      print('-----USUARIO NULO------');
    }
  }

  Future<void> _updateCourseToState(
      CourseInfoLoaded event, Emitter<CourseDetailsState> emit) async {
    emit(CourseLoaded(event.loadedCourse, const <Task>[]));
  }
}
