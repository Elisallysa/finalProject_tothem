import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/screens/welcome/widgets/login_widgets.dart';
import 'package:tothem/theme/tothem_theme.dart';
import 'bloc/welcome_blocs.dart';
import 'bloc/welcome_events.dart';
import 'bloc/welcome_states.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WelcomeBloc, WelcomeState>(builder: (context, state) {
        return SafeArea(
            child: Scaffold(
                backgroundColor: TothemTheme.lightGreen,
                body: SingleChildScrollView(
                    child: buildLoginComponents(context, (value) {
                  context.read<WelcomeBloc>().add(MailEvent(value));
                }, (value) {
                  context.read<WelcomeBloc>().add(PwdEvent(value));
                }))));
      }),
    );
  }
}

Widget buildLoginComponents(
    BuildContext context,
    void Function(String value) mailFunction,
    void Function(String value) pwdFunction) {
  return Column(children: [
    buildUpperBox(context, 0.30, '7.png'),
    buildLowerBox(context, Colors.white, false, 'Iniciar sesión', mailFunction,
        pwdFunction)
  ]);
}
