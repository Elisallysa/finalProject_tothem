import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tothem/src/screens/my_courses/home_screen.dart';
import 'package:tothem/src/screens/my_courses/my_courses_screen.dart';
import '/firebase_options.dart';

import 'package:tothem/src/screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TothemApp());
}

class TothemApp extends StatelessWidget {
  const TothemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WelcomeBloc()),
        ChangeNotifierProvider(create: (context) => AuthService())
      ],
      child: ScreenUtilInit(
        builder: (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'tothem',
            initialRoute: '/login',
            //home: const Login(),
            routes: {
              '/login': (_) => const Login(),
              '/signup': (_) => const Signup(),
              '/home': (_) => const HomeScreen(),
            },
            theme: TothemTheme.getTothemTheme()),
      ),
    );
  }
}