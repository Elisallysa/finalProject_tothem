import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/app_blocs.dart';
import 'package:tothem/screens/welcome/bloc/welcome_blocs.dart';
import 'package:tothem/screens/welcome/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  runApp(const FitBrain());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class FitBrain extends StatelessWidget {
  const FitBrain({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => WelcomeBloc())],
      child: ScreenUtilInit(
          builder: (context, child) => const MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'tothem',
                home: Login(),
              )),
    );
  }
}
