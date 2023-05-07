import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/repository/User_repository/User_repository.dart';
import 'package:tothem/src/repository/bloc/user/user_events.dart';
import 'package:tothem/src/repository/bloc/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  StreamSubscription? _userSubscription;

  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserLoading()) {
    on<NewUserRegistered>((event, emit) async {
      await _saveUserIntoDatabase(event, emit);
    });
  }

  Future<void> _saveUserIntoDatabase(
      NewUserRegistered event, Emitter<UserState> emit) async {
    _userSubscription?.cancel();
    _userSubscription = await _userRepository.createUser(event.user!).then((_) {
      emit(UserSaved(event
          .user!)); // Emitir estado de "UserSaved" después de guardar el usuario
    }, onError: (error) {
      emit(UserError(
          error.toString())); // Emitir estado de "UserError" en caso de error
    });
  }
}
