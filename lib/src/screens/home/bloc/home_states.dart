import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';

import '../../../models/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// [HomeState] transmits the events to BLoC in order to perform the corresponding logic.
class HomeState extends Equatable {
  final AuthStatus status;
  final auth.User? authUser;
  final User? user;

  const HomeState._(
      {this.status = AuthStatus.unknown, this.authUser, this.user});

  const HomeState.unknown() : this._();

  const HomeState.authenticated({
    required auth.User authUser,
    required User user,
  }) : this._(status: AuthStatus.authenticated, authUser: authUser, user: user);

  const HomeState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, authUser, user];
}
