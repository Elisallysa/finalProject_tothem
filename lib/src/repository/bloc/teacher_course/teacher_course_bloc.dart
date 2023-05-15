import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/repository/auth_repository/auth_repository.dart';
import 'package:tothem/src/repository/bloc/teacher_course/teacher_course_events.dart';
import 'package:tothem/src/repository/bloc/teacher_course/teacher_course_state.dart';
import '../../course_repository/course_repository.dart';

class TeacherCourseBloc extends Bloc<TeacherCourseEvent, TeacherCourseState> {
  final CourseRepository _courseRepository;
  StreamSubscription? _courseSubscription;
  final AuthRepository _authRepository;

  TeacherCourseBloc(
      {required AuthRepository authRepository,
      required CourseRepository courseRepository})
      : _authRepository = authRepository,
        _courseRepository = courseRepository,
        super(TeacherCourseLoading()) {
    on<LoadTeacherCourses>((event, emit) async {
      await _mapLoadCoursesToState(emit);
    });
    on<UpdateTeacherCourses>(
        (event, emit) => _mapUpdateCoursesToState(event, emit));
    on<AddTeacherCourse>((event, emit) => _createNewTeacherCourse(event, emit));
  }

  Future<void> _mapLoadCoursesToState(Emitter<TeacherCourseState> emit) async {
    _courseSubscription?.cancel();

    User? user = _authRepository.getUser();
    if (user != null) {
      _courseSubscription = _courseRepository
          .getTeacherCourses(user.email!)
          .listen((courses) => add(UpdateTeacherCourses(courses)));
    } else {
      print('-----USUARIO NULO------');
    }
  }

  Future<void> _mapUpdateCoursesToState(
      UpdateTeacherCourses event, Emitter<TeacherCourseState> emit) async {
    emit(TeacherCourseLoaded(courses: event.courses));
  }

  _createNewTeacherCourse(event, Emitter<TeacherCourseState> emit) {}
}
