import 'package:equatable/equatable.dart';
import 'package:tothem/src/models/user.dart';

class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewUserRegistered extends UserEvent {
  final User? user;

  NewUserRegistered({this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUser extends UserEvent {
  final User user;

  UpdateUser(this.user);

  @override
  List<Object?> get props => [user];
}
