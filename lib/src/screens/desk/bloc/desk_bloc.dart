import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/models/course_category.dart';
import 'package:tothem/src/repository/auth_repository/auth_repository.dart';
import 'package:tothem/src/repository/category_repository/category_repository.dart';
import 'package:tothem/src/repository/course_repository/course_repository.dart';
import 'package:tothem/src/repository/user_repository/user_repository.dart';
import 'package:tothem/src/screens/desk/desk.dart';

class DeskBloc extends Bloc<DeskEvent, DeskState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final CourseRepository _courseRepository;
  final CategoryRepository _categoryRepository;
  StreamSubscription<auth.User?>? _authUserSubscription;
  StreamSubscription<User?>? _userSubscription;

  DeskBloc(
      {required AuthRepository authRepository,
      required UserRepository userRepository,
      required CourseRepository courseRepository,
      required CategoryRepository categoryRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        _courseRepository = courseRepository,
        _categoryRepository = categoryRepository,
        super(const DeskState.unknown(categoriesList: <CourseCategory>[])) {
    on<AuthUserChanged>(_onAuthUserChanged);
    List<CourseCategory> categoriesList = <CourseCategory>[];
    _categoryRepository.getAllCategories().listen((categories) {
      for (var category in categories) {
        categoriesList.add(category);
      }
    });

    _authUserSubscription = _authRepository.user.listen((authUser) {
      print('Auth user: $authUser');
      if (authUser != null) {
        _userRepository.getUser(authUser.uid).listen((user) {
          add(AuthUserChanged(
              authUser: authUser, user: user, categoriesList: categoriesList));
        });
      } else {
        add(AuthUserChanged(authUser: authUser));
      }
    });

    on<CreateCourseEvent>(_createTeacherCourse);
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<DeskState> emit) {
    event.authUser != null
        ? emit(DeskState.authenticated(
            authUser: event.authUser!,
            user: event.user!,
            categoriesList: event.categoriesList ?? <CourseCategory>[]))
        : emit(DeskState.unauthenticated(
            categoriesList: event.categoriesList ?? <CourseCategory>[]));
  }

  void _createTeacherCourse(CreateCourseEvent event, Emitter<DeskState> emit) {
    try {
      _courseRepository.createCourse(event.course, event.authUser);
      emit(DeskState.createCourse(event.course));
    } catch (e) {
      print(e);
      emit(DeskState.unknown(
          categoriesList: event.categoriesList ?? <CourseCategory>[]));
    }
  }

  @override
  Future<void> close() {
    _authUserSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
