import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tothem/src/models/course.dart';

import '../../../models/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// [DeskState] transmits the events to BLoC in order to perform the corresponding logic.
class DeskState extends Equatable {
  final AuthStatus status;
  final auth.User? authUser;
  final User? user;
  final Course? course;
  final List<String>? categoriesList;

  const DeskState._(
      {this.status = AuthStatus.unknown,
      this.authUser,
      this.user,
      this.course,
      this.categoriesList});

  const DeskState.unknown({required List<String> categoriesList})
      : this._(categoriesList: categoriesList);

  const DeskState.authenticated({
    required auth.User authUser,
    required User user,
    required List<String> categoriesList,
  }) : this._(
            status: AuthStatus.authenticated,
            authUser: authUser,
            user: user,
            categoriesList: categoriesList);

  const DeskState.unauthenticated({required List<String> categoriesList})
      : this._(
            status: AuthStatus.unauthenticated, categoriesList: categoriesList);

  const DeskState.createCourse(Course newCourse) : this._(course: newCourse);

  @override
  List<Object?> get props => [status, authUser, user];
}
