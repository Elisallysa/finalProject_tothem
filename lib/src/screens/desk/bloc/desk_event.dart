import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/course_category.dart';

import '../../../models/user.dart';

abstract class DeskEvent extends Equatable {
  final List<CourseCategory>? categoriesList;

  const DeskEvent({this.categoriesList});

  @override
  List<Object> get props => [];
}

class AuthUserChanged extends DeskEvent {
  final auth.User? authUser;
  final User? user;

  const AuthUserChanged(
      {super.categoriesList, required this.authUser, this.user});

  @override
  List<Object> get props => [];
}

class NewUserRegistered extends DeskEvent {
  final auth.User? authUser;
  final User? user;

  const NewUserRegistered({required this.authUser, this.user});

  @override
  List<Object> get props => [];
}

class CreateCourseEvent extends DeskEvent {
  final Course course;
  final auth.User authUser;
  const CreateCourseEvent(this.course, this.authUser);
  @override
  List<Object> get props => [course, authUser];
}
