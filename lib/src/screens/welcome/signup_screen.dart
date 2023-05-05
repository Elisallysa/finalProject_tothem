import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/src/screens/screens.dart';

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
                    child: buildSignupComponents(context, (value) {
                  context.read<WelcomeBloc>().add(MailEvent(value));
                }, (value) {
                  context.read<WelcomeBloc>().add(PwdEvent(value));
                }, (value) {
                  context.read<WelcomeBloc>().add(RePwdEvent(value));
                }, () {
                  context.read<UserBloc>().add(NewUserRegistered());
                }, () {
                  WelcomeController(context: context).handleSignUp("mail");
                }, () {
                  WelcomeController(context: context).handleSignUp("google");
                }))));
      }),
    );
  }
}

Widget buildSignupComponents(
    BuildContext context,
    void Function(String value)? mailFunction,
    void Function(String value)? pwdFunction,
    void Function(String value)? rePwdFunction,
    void Function() saveUserInDB,
    void Function() handleSignUp,
    void Function() handleGoogleSignUp) {
  return Column(children: [
    buildUpperBox(context, 0.30, '9.png'),
    buildLowerBox(
        context: context,
        color: Colors.white,
        wrongCredentials: false,
        title: 'Regístrate',
        mailFunction: mailFunction,
        pwdFunction: pwdFunction,
        rePwdFunction: rePwdFunction,
        saveUserInDB: saveUserInDB,
        buttonFunction: handleSignUp,
        googleButtonFunction: handleGoogleSignUp)
  ]);
}
