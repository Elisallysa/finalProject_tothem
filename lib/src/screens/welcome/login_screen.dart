import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/screens/screens.dart';

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
                }, () {
                  WelcomeController(context: context).handleSignIn("mail");
                }, () {
                  WelcomeController(context: context).handleSignIn("google");
                }))));
      }),
    );
  }
}

Widget buildLoginComponents(
    BuildContext context,
    void Function(String value) mailFunction,
    void Function(String value) pwdFunction,
    void Function() handleLogIn,
    void Function() handleGoogleLogIn) {
  return Column(children: [
    buildUpperBox(context, 0.30, '7.png'),
    buildLowerBox(
        context: context,
        color: Colors.white,
        wrongCredentials: false,
        title: 'Iniciar sesión',
        mailFunction: mailFunction,
        pwdFunction: pwdFunction,
        buttonFunction: handleLogIn,
        googleButtonFunction: handleGoogleLogIn)
  ]);
}
