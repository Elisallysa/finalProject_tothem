import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../course_repository/course_repository.dart';
import 'course_events.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;
  StreamSubscription? _courseSubscription;

  CourseBloc({required CourseRepository courseRepository})
      : _courseRepository = courseRepository,
        super(CourseLoading()) {
    on<LoadCourses>((event, emit) async {
      await _mapLoadCoursesToState(emit);
    });
    on<UpdateCourses>((event, emit) => _mapUpdateCoursesToState(event, emit));
  }

  Future<void> _mapLoadCoursesToState(Emitter<CourseState> emit) async {
    _courseSubscription?.cancel();
    _courseSubscription = _courseRepository
        .getAllCourses()
        .listen((courses) => add(UpdateCourses(courses)));
  }

  Future<void> _mapUpdateCoursesToState(
      UpdateCourses event, Emitter<CourseState> emit) async {
    emit(CourseLoaded(courses: event.courses));
  }
}
