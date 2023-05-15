import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../../models/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// [DeskState] transmits the events to BLoC in order to perform the corresponding logic.
class DeskState extends Equatable {
  final AuthStatus status;
  final auth.User? authUser;
  final User? user;

  const DeskState._(
      {this.status = AuthStatus.unknown, this.authUser, this.user});

  const DeskState.unknown() : this._();

  const DeskState.authenticated({
    required auth.User authUser,
    required User user,
  }) : this._(status: AuthStatus.authenticated, authUser: authUser, user: user);

  const DeskState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, authUser, user];
}
