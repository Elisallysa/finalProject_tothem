import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tothem/src/repository/bloc/category/category_bloc.dart';
import 'package:tothem/src/repository/category_repository/category_repository.dart';
import 'package:tothem/src/screens/home/bloc/home_blocs.dart';
import 'package:tothem/src/screens/home/home_screen.dart';
import 'package:tothem/src/screens/home/home_screen.dart';
import 'firebase_options.dart';

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
        BlocProvider(create: (_) => WelcomeBloc()),
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(
            create: (_) =>
                CategoryBloc(categoryRepository: CategoryRepository())),
        ChangeNotifierProvider(create: (context) => AuthService())
      ],
      child: ScreenUtilInit(
        builder: (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'tothem',
            initialRoute: '/home',
            //home: const Login(),
            routes: {
              '/login': (_) => const Login(),
              '/signup': (_) => const Signup(),
              '/home': (_) => const HomeScreen(),
            },
            theme: TothemTheme.getSeedTheme()),
      ),
    );
  }
}
