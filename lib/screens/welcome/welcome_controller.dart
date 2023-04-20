import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tothem/screens/welcome/bloc/welcome_blocs.dart';

class WelcomeController {
  final BuildContext context;
  const WelcomeController({required this.context});

  Future<void> handleSignIn(String type) async {
    try {
      if (type == "mail") {
        // We could do the same using:
        // BlocProvider.of<WelcomeBloc>(context).state
        // to access the Bloc that we created.
        final state = context.read<WelcomeBloc>().state;
        String emailAddress = state.mail;
        String pwd = state.password;
        if (emailAddress.isEmpty) {
          //TO DO
        }
        if (pwd.isEmpty) {
          //TO DO
        }
        try {
          final credentials = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: emailAddress, password: pwd);
          if (credentials.user == null) {}
          if (!credentials.user!.emailVerified) {}

          var user = credentials.user;
          if (user != null) {
            // We get a verified user from Firebase
          } else {
            // We get an error when verifying user
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {}
  }
}
