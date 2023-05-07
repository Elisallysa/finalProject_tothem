import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../../models/user.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthUserChanged extends HomeEvent {
  final auth.User? authUser;
  final User? user;

  AuthUserChanged({required this.authUser, this.user});

  @override
  List<Object> get props => [];
}

class NewUserRegistered extends HomeEvent {
  final auth.User? authUser;
  final User? user;

  NewUserRegistered({required this.authUser, this.user});

  @override
  List<Object> get props => [];
}
