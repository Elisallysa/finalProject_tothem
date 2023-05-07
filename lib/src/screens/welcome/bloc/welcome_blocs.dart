import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/screens/welcome/bloc/welcome_events.dart';
import 'package:tothem/src/screens/welcome/bloc/welcome_states.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(const WelcomeState()) {
    on<MailEvent>(_mailEvent);

    on<PwdEvent>(_pwdEvent);

    on<RePwdEvent>(_repeatPwdEvent);
  }

  void _mailEvent(MailEvent event, Emitter<WelcomeState> emit) {
    //print('myemail is ${event.mail}');
    emit(state.copyWith(mail: event.mail));
  }

  void _pwdEvent(PwdEvent event, Emitter<WelcomeState> emit) {
    //print('my pass is ${event.password}');
    emit(state.copyWith(password: event.password));
  }

  void _repeatPwdEvent(RePwdEvent event, Emitter<WelcomeState> emit) {
    emit(state.copyWith(repeatPassword: event.repeatPassword));
  }
}
