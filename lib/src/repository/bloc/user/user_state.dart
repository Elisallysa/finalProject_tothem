import 'package:equatable/equatable.dart';
import 'package:tothem/src/models/user.dart';

class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class InitStates extends UserState {
  const InitStates() : super();
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {}

class UserSaved extends UserState {
  final User user;

  const UserSaved(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String errorMessage;

  const UserError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
