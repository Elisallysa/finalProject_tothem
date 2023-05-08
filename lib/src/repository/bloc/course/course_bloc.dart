import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/repository/auth_repository/auth_repository.dart';

import '../../course_repository/course_repository.dart';
import 'course_events.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;
  StreamSubscription? _courseSubscription;
  final AuthRepository _authRepository;

  CourseBloc(
      {required AuthRepository authRepository,
      required CourseRepository courseRepository})
      : _authRepository = authRepository,
        _courseRepository = courseRepository,
        super(CourseLoading()) {
    on<LoadCourses>((event, emit) async {
      await _mapLoadCoursesToState(emit);
    });
    on<UpdateCourses>((event, emit) => _mapUpdateCoursesToState(event, emit));
  }

  Future<void> _mapLoadCoursesToState(Emitter<CourseState> emit) async {
    _courseSubscription?.cancel();

    User? user = _authRepository.getUser();
    if (user != null) {
      _courseSubscription = _courseRepository
          .getRegCourses(user.uid)
          .asStream()
          .listen((courses) => add(UpdateCourses(courses)));
    } else {
      print('-----USUARIO NULO------');
    }
  }

  Future<void> _mapUpdateCoursesToState(
      UpdateCourses event, Emitter<CourseState> emit) async {
    emit(CourseLoaded(courses: event.courses));
  }
}
