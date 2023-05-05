import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => UserRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => WelcomeBloc()),
          BlocProvider(
              create: (context) => HomeBloc(
                  authRepository: context.read<AuthRepository>(),
                  userRepository: context.read<UserRepository>())),
          BlocProvider(
              create: (_) => CategoryBloc(
                    categoryRepository: CategoryRepository(),
                  )..add(LoadCategories())),
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
              theme: TothemTheme.getSeedTheme()),
        ),
      ),
    );
  }
}
