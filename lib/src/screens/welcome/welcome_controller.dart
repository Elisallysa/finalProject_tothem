import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tothem/src/screens/welcome/bloc/welcome_blocs.dart';
import 'package:tothem/src/common/widgets/flutter_toast.dart';

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
          toastInfo(msg: "Introduce tu Email.");
        }
        if (pwd.isEmpty) {
          toastInfo(msg: "Introduce tu contraseña.");
        }
        try {
          final credentials = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: emailAddress, password: pwd);
          if (credentials.user == null) {
            toastInfo(
                msg:
                    "Email no registrado. Revisa tu Email o regístrate en la página de registro.");
          }
          if (!credentials.user!.emailVerified) {
            toastInfo(
                msg:
                    "Aún no has verificado tu cuenta. Por favor, revisa tus Emails y verifícala.",
                backgroundColor: Colors.black);
          }

          var user = credentials.user;
          if (user != null) {
            // We get a verified user from Firebase
          } else {
            // We get an error when verifying user
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            toastInfo(msg: "Usuario no encontrado.");
          } else if (e.code == 'wrong-password') {
            toastInfo(msg: "Contraseña incorrecta.");
          } else if (e.code == 'invalid-email') {
            toastInfo(msg: "El Email parece incorrecto. Revísalo.");
          }
        } catch (e) {
          toastInfo(msg: "¡Ups! Error inesperado. Recarga la aplicación.");
        }
      } else if (type == 'google') {
        _handleGoogleSignIn();
      }
    } catch (e) {}
  }

  Future<void> handleSignUp(String type) async {
    try {
      if (type == "mail") {
        final state = context.read<WelcomeBloc>().state;
        String emailAddress = state.mail;
        String pwd = state.password;
        String rePwd = state.repeatPassword;

        if (emailAddress.isEmpty || pwd.isEmpty || rePwd.isEmpty) {
          toastInfo(msg: "Rellena todos los campos.");
        } else if (pwd != rePwd) {
          toastInfo(msg: "Las contraseñas no coinciden.");
        } else {
          try {
            final credentials = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: emailAddress, password: pwd);
            if (credentials.user == null) {
              toastInfo(
                  msg:
                      "Ha habido algún error en el registro. Pruebe otra vez.");
            }
            if (!credentials.user!.emailVerified) {
              toastInfo(msg: "¡Bienvenido! Recuerda verificar tu Email.");
              // TO DO: OPEN HOME
            }

            var user = credentials.user;
            if (user != null) {
              // We get a verified user from Firebase
            } else {
              // We get an error when verifying user
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'email-already-in-use') {
              toastInfo(msg: "Esta cuenta ya está registrada.");
            } else if (e.code == 'weak-password') {
              toastInfo(
                  msg: "La contraseña debe contener mínimo 6 caracteres.");
            } else if (e.code == 'invalid-email') {
              toastInfo(
                  msg:
                      "El Email parece incorrecto. Revísalo o utiliza otra dirección de Email.");
            }
          } catch (e) {
            toastInfo(msg: "¡Ups! Error inesperado. Recarga la aplicación.");
          }
        }
      } else if (type == 'google') {
        _handleGoogleSignIn();
      }
    } catch (e) {}
  }

  /// Handles registering user with Google account.
  Future<void> _handleGoogleSignIn() async {
    // Begin interactive log in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain authentication details from request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create credentials for the user
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    FirebaseAuth.instance.signInWithCredential(credential);
  }
}
