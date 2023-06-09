import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/repository/bloc/bloc.dart';

class TeacherCourseBloc extends Bloc<TeacherCourseEvent, TeacherCourseState> {
  final CourseRepository _courseRepository;
  StreamSubscription? _courseSubscription;
  final CategoryRepository _categoryRepository;
  StreamSubscription? _categoryeSubscription;
  final AuthRepository _authRepository;

  TeacherCourseBloc({
    required AuthRepository authRepository,
    required CourseRepository courseRepository,
    required CategoryRepository categoryRepository,
  })  : _authRepository = authRepository,
        _courseRepository = courseRepository,
        _categoryRepository = categoryRepository,
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

    Map<String, String> categoriesMap = {};

    categoriesMap = await _categoryRepository.getCategoriesMap();

    User? user = _authRepository.getUser();
    if (user != null) {
      _courseSubscription =
          _courseRepository.getTeacherCourses(user.email!).listen((courses) {
        courses.sort((a, b) => a.compareTo(b));

        add(UpdateTeacherCourses(courses, categoriesMap));
      });
    } else {
      print('-----USUARIO NULO------');
    }
  }

  Future<void> _mapUpdateCoursesToState(
      UpdateTeacherCourses event, Emitter<TeacherCourseState> emit) async {
    emit(TeacherCourseLoaded(
        courses: event.courses, categories: event.categories));
  }

  _createNewTeacherCourse(event, Emitter<TeacherCourseState> emit) {}
}
