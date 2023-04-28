import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_events.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<UserInfoEvent>(_userInfoEvent);
  }

  void _userInfoEvent(UserInfoEvent event, Emitter<HomeState> emit) {
    //print('myemail is ${event.mail}');
    emit(state.copyWith(userName: event.userName));
  }
}
