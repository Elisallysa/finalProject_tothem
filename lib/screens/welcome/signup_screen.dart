import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/screens/welcome/bloc/welcome_events.dart';
import 'package:tothem/screens/welcome/widgets/login_widgets.dart';
import 'package:tothem/theme/tothem_theme.dart';
import 'bloc/welcome_blocs.dart';
import 'bloc/welcome_states.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

  final Map<String, String> formValues = {'email': '', 'password': ''};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: myFormKey,
      body: BlocBuilder<WelcomeBloc, WelcomeState>(builder: (context, state) {
        return SafeArea(
            child: Scaffold(
                backgroundColor: TothemTheme.lightGreen,
                body: SingleChildScrollView(
                    child: buildSigninComponents(context, (value) {
                  context.read<WelcomeBloc>().add(MailEvent(value));
                }, (value) {
                  context.read<WelcomeBloc>().add(PwdEvent(value));
                }))));
      }),
    );
  }
}

Widget buildSigninComponents(
    BuildContext context,
    void Function(String value)? mailFunction,
    void Function(String value)? pwdFunction) {
  return Column(children: [
    buildUpperBox(context, 0.30, '9.png'),
    buildLowerBox(
        context, Colors.white, false, 'Regístrate', mailFunction, pwdFunction)
  ]);
}
