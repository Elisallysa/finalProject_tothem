import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/repository/auth_repository/auth_repository.dart';
import 'package:tothem/src/repository/bloc/bloc.dart';

import '../../course_repository/course_repository.dart';
import 'course_events.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;
  StreamSubscription? _courseSubscription;
  final CategoryRepository _categoryRepository;
  final AuthRepository _authRepository;

  CourseBloc(
      {required AuthRepository authRepository,
      required CourseRepository courseRepository,
      required CategoryRepository categoryRepository})
      : _authRepository = authRepository,
        _courseRepository = courseRepository,
        _categoryRepository = categoryRepository,
        super(CourseLoading()) {
    on<LoadCourses>((event, emit) async {
      await _mapLoadCoursesToState(emit);
    });
    on<UpdateCourses>((event, emit) => _mapUpdateCoursesToState(event, emit));

    on<JoinCourse>((event, emit) {
      _joinCourse(event);
    });
  }

  Future<void> _mapLoadCoursesToState(Emitter<CourseState> emit) async {
    _courseSubscription?.cancel();

    Map<String, String> catMap = await _categoryRepository.getCategoriesMap();

    User? user = _authRepository.getUser();
    if (user != null) {
      _courseSubscription = _courseRepository
          .getRegCourses(user.uid)
          .asStream()
          .listen((courses) => add(UpdateCourses(courses, catMap)));
    } else {
      print('-----USUARIO NULO------');
    }
  }

  Future<void> _mapUpdateCoursesToState(
      UpdateCourses event, Emitter<CourseState> emit) async {
    emit(CourseLoaded(event.categoriesMap, courses: event.courses));
  }

  Future<void> _joinCourse(JoinCourse event) async {
    Map<String, String> catMap = await _categoryRepository.getCategoriesMap();

    User? user = _authRepository.getUser();
    if (user != null) {
      List<Course> regCourses =
          await _courseRepository.getRegCourses(event.user.uid);

      await _courseRepository.joinCourse(
          event.courseCode, regCourses, event.user);
      List<Course> updatedRegCourses =
          await _courseRepository.getRegCourses(event.user.uid);
      add(UpdateCourses(updatedRegCourses, catMap));
    }
  }
}
