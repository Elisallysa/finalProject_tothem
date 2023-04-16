import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/screens/welcome/bloc/welcome_events.dart';
import 'package:tothem/screens/welcome/bloc/welcome_states.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeState()) {
    on<MailEvent>(_mailEvent);

    on<PwdEvent>(_pwdEvent);
  }

  void _mailEvent(MailEvent event, Emitter<WelcomeState> emit) {
    emit(state.copyWith(mail: event.mail));
  }

  void _pwdEvent(PwdEvent event, Emitter<WelcomeState> emit) {
    emit(state.copyWith(mail: event.password));
  }
}
