import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tothem/src/screens/desk/bloc/desk_bloc.dart';
import 'src/firebase_options.dart';
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
        RepositoryProvider(
            key: UniqueKey(), create: (context) => AuthRepository()),
        RepositoryProvider(
            key: UniqueKey(), create: (context) => UserRepository()),
        RepositoryProvider(
            key: UniqueKey(), create: (context) => CourseRepository()),
        RepositoryProvider(
            key: UniqueKey(), create: (context) => CategoryRepository())
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
          BlocProvider(
              create: (context) => CourseBloc(
                  authRepository: context.read<AuthRepository>(),
                  courseRepository: context.read<CourseRepository>())
                ..add(LoadCourses())),
          BlocProvider(
              create: (context) => TeacherCourseBloc(
                  authRepository: context.read<AuthRepository>(),
                  courseRepository: context.read<CourseRepository>())
                ..add(LoadTeacherCourses())),
          BlocProvider(
              create: (context) => DeskBloc(
                  authRepository: context.read<AuthRepository>(),
                  userRepository: context.read<UserRepository>(),
                  courseRepository: context.read<CourseRepository>(),
                  categoryRepository: context.read<CategoryRepository>())),
          ChangeNotifierProvider(create: (context) => AuthService())
        ],
        child: ScreenUtilInit(
          builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'tothem',
              initialRoute: '/desk',
              //home: const Login(),
              routes: {
                '/login': (_) => const Login(),
                '/signup': (_) => const Signup(),
                '/home': (_) => const HomeScreen(),
                '/desk': (_) => const DeskScreen()
              },
              theme: TothemTheme.getSeedTheme()),
        ),
      ),
    );
  }
}
