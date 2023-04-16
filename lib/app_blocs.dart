import 'package:tothem/app_events.dart';
import 'package:tothem/app_states.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocs extends Bloc<AppEvents, AppStates> {
  AppBlocs() : super(InitStates()) {
    on<Login>((event, emit) => print('hello'));
    on<Register>((event, emit) {
      emit(AppStates(counter: state.counter + 1));
    });
  }
}
