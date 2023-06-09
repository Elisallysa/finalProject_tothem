import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tothem/src/repository/content_repository/content_repository.dart';
import 'package:tothem/src/repository/task_repository/task_repository.dart';
import 'package:tothem/src/screens/task_details/task_details_screen.dart';
import 'src/firebase_options.dart';
import 'package:tothem/src/repository/bloc/task/task_bloc.dart';

import 'package:tothem/src/screens/screens.dart';

import 'src/screens/tasks_screen/bloc/tasks_screen_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
/*
// Configurar App Check
  final firebaseAppCheck = FirebaseAppCheck.instance;

  await firebaseAppCheck.activate(
    // personal reCaptcha public key
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  */
  runApp(TothemApp());

  //FirebaseAuth.instance.signOut();
}

class TothemApp extends StatelessWidget {
  String? appCheckToken;
  TothemApp({super.key, String? appCheckToken});

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
            key: UniqueKey(), create: (context) => CategoryRepository()),
        RepositoryProvider(
            key: UniqueKey(), create: (context) => ContentRepository()),
        RepositoryProvider(
            key: UniqueKey(), create: (context) => TaskRepository())
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
              create: (context) => TaskBloc(
                  authRepository: context.read<AuthRepository>(),
                  taskRepository: context.read<TaskRepository>(),
                  courseRepository: context.read<CourseRepository>())),
          BlocProvider(
              create: (context) => TeacherCourseBloc(
                  authRepository: context.read<AuthRepository>(),
                  courseRepository: context.read<CourseRepository>(),
                  categoryRepository: context.read<CategoryRepository>())
                ..add(LoadTeacherCourses())),
          BlocProvider(
              create: (context) => DeskBloc(
                  authRepository: context.read<AuthRepository>(),
                  userRepository: context.read<UserRepository>(),
                  courseRepository: context.read<CourseRepository>(),
                  categoryRepository: context.read<CategoryRepository>())),
          BlocProvider(
              create: (context) => CourseDetailsBloc(
                  authRepository: context.read<AuthRepository>(),
                  courseRepository: context.read<CourseRepository>(),
                  contentRepository: context.read<ContentRepository>(),
                  taskRepository: context.read<TaskRepository>())),
          BlocProvider(
              create: (context) => TasksScreenBloc(
                  authRepository: context.read<AuthRepository>(),
                  courseRepository: context.read<CourseRepository>(),
                  contentRepository: context.read<ContentRepository>(),
                  taskRepository: context.read<TaskRepository>())),
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
                '/desk': (_) => const DeskScreen(),
                '/coursedeets': (_) => CourseDetailsScreen(),
                '/taskdeets': (_) => TaskDetailsScreen()
              },
              theme: TothemTheme.getSeedTheme()),
        ),
      ),
    );
  }
}
