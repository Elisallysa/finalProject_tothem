import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';
import 'package:tothem/src/common/widgets/tothem_bottom_app_bar.dart';
import 'package:tothem/src/common/widgets/tothem_common_widgets.dart';
import 'package:tothem/src/models/course.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tothem/src/screens/course_details/widgets/task_card.dart';
import 'package:tothem/src/screens/tasks_screen/bloc/tasks_screen_bloc.dart';
import 'package:tothem/src/screens/tasks_screen/bloc/tasks_screen_event.dart';
import 'package:tothem/src/screens/tasks_screen/bloc/tasks_screen_state.dart';

class TasksScreen extends StatefulWidget {
  Course _course;
  auth.User? _authUser;

  TasksScreen({
    Key? key,
    Course? course,
    auth.User? authUser,
  })  : _course =
            course ?? const Course(id: 'aerodriguez420230520TRANTI', title: ''),
        _authUser = authUser ?? auth.FirebaseAuth.instance.currentUser,
        super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<TasksScreenBloc>(context)
          .add(CourseLoading(widget._course));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: BlocBuilder<TasksScreenBloc, TasksScreenState>(
            builder: (context, state) {
          if (state is CourseLoaded) {
            return Scaffold(
                bottomNavigationBar: TothemBottomAppBar(key: widget.key),
                appBar: AppBar(
                    title: Text(state.course.title),
                    shadowColor: Theme.of(context).shadowColor,
                    bottom: const TabBar(
                      tabs: [
                        Tab(text: 'Todas'),
                        Tab(text: 'No completadas'),
                        Tab(text: 'Completadas'),
                      ],
                    )),
                body: TabBarView(
                  children: <Widget>[
                    ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          if (state.tasks.isNotEmpty) {
                            return Column(
                                children: state.tasks.map((task) {
                              return TaskCard(
                                checkboxFunction: (bool value, context) {
                                  context.read<TasksScreenBloc>().add(
                                        CheckboxChangedEvent(
                                          courseId: state.course.id!,
                                          taskId: task.id,
                                          isChecked: value,
                                        ),
                                      );
                                },
                                task: task,
                                isChecked: task.done,
                                courseId: state.course.id!,
                              );
                            }).toList());
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: Column(
                                children: [
                                  SizedBox(
                                      width: 250.w,
                                      child: Image.asset(
                                          'assets/images/free.png')),
                                  Text('No tienes tareas asignadas.',
                                      style: TothemTheme.bodyText,
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            );
                          }
                        }),
                    Icon(Icons.directions_transit),
                    Icon(Icons.directions_bike),
                  ],
                ));
          } else if (state is CourseError) {
            return Scaffold(
                appBar: AppBar(title: const Text('Curso no encontrado')),
                bottomNavigationBar: TothemBottomAppBar(key: widget.key),
                body: whiteBackgroundContainer(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 250.w,
                          child: Image.asset('assets/images/confused.png')),
                      Text('No se ha podido encontrar el curso seleccionado.',
                          style: TothemTheme.bodyText,
                          textAlign: TextAlign.center),
                    ],
                  ),
                ));
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text('Cargando el curso...')),
              bottomNavigationBar: TothemBottomAppBar(key: widget.key),
              body: whiteBackgroundContainer(
                  const Center(child: CircularProgressIndicator())),
            );
          }
        }),
      ),
    );
  }
}
