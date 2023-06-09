import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';
import 'package:tothem/src/common/widgets/tothem_bottom_app_bar.dart';
import 'package:tothem/src/common/widgets/tothem_common_widgets.dart';
import 'package:tothem/src/models/course.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/screens/course_details/widgets/task_card.dart';
import 'package:tothem/src/screens/tasks_screen/bloc/tasks_screen_bloc.dart';
import 'package:tothem/src/screens/tasks_screen/bloc/tasks_screen_event.dart';
import 'package:tothem/src/screens/tasks_screen/bloc/tasks_screen_state.dart';

class TasksScreen extends StatefulWidget {
  Course? _course;
  auth.User? _authUser;

  TasksScreen({
    Key? key,
    Course? course,
    auth.User? authUser,
  })  : _authUser = authUser ?? auth.FirebaseAuth.instance.currentUser,
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
    return DefaultTabController(
      length: 3,
      child: BlocBuilder<TasksScreenBloc, TasksScreenState>(
          builder: (context, state) {
        if (state is CourseLoaded) {
          return Scaffold(
              bottomNavigationBar: TothemBottomAppBar(key: widget.key),
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(state.course.title.isNotEmpty
                      ? state.course.title
                      : 'Tus tareas'),
                  bottom: const TabBar(
                    dividerColor: Colors.white,
                    tabs: [
                      Tab(text: 'Todas'),
                      Tab(text: 'Pendientes'),
                      Tab(text: 'Completadas'),
                    ],
                  )),
              body: TabBarView(
                children: <Widget>[
                  courseTasksListView(state.tasks, state.course, null),
                  courseTasksListView(state.tasks, state.course, false),
                  courseTasksListView(state.tasks, state.course, true)
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
        } else if (state is AllTasksLoaded) {
          return Scaffold(
              bottomNavigationBar: TothemBottomAppBar(key: widget.key),
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Tus tareas'),
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Todas'),
                      Tab(text: 'Pendientes'),
                      Tab(text: 'Completadas'),
                    ],
                  )),
              body: TabBarView(children: <Widget>[
                tasksListView(state.coursesAndTasks, null),
                tasksListView(state.coursesAndTasks, false),
                tasksListView(state.coursesAndTasks, true),
              ]));
        } else {
          return Scaffold(
            appBar: AppBar(
                title: const Text('Cargando...'),
                automaticallyImplyLeading: false),
            bottomNavigationBar: TothemBottomAppBar(key: widget.key),
            body: whiteBackgroundContainer(
                const Center(child: CircularProgressIndicator())),
          );
        }
      }),
    );
  }
}

/// ListView of TaskCards of Tasks in [courseTasks], which are [course]'s tasks.
/// [doneNotDone] null if no filter is needed, true if Task.done == true and
/// false if Task.done == false
ListView courseTasksListView(
    List<Task> courseTasks, Course course, bool? doneNotDone) {
  List<Task> filteredTasks = [];
  if (courseTasks.isNotEmpty) {
    if (doneNotDone != null) {
      filteredTasks.addAll(courseTasks.where((tsk) => tsk.done == doneNotDone));
    } else {
      filteredTasks.addAll(courseTasks);
    }
  }

  return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        if (filteredTasks.isNotEmpty) {
          return Column(
              children: filteredTasks.map((task) {
            return TaskCard(
              checkboxFunction: (bool value, context) {
                context.read<TasksScreenBloc>().add(
                      CheckboxChangedEvent(
                        courseId: course.id!,
                        taskId: task.id,
                        isChecked: value,
                      ),
                    );
              },
              task: task,
              isChecked: task.done,
              courseId: course.id!,
            );
          }).toList());
        } else {
          String message = '';

          if (doneNotDone == null) {
            message = 'No tienes tareas asignadas.';
          } else if (doneNotDone == true) {
            message = 'No tienes tareas completadas.';
          } else if (doneNotDone == false) {
            message = 'No tienes tareas pendientes.';
          }

          return Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Column(
              children: [
                SizedBox(
                    width: 250.w, child: Image.asset('assets/images/free.png')),
                Text(message,
                    style: TothemTheme.bodyText, textAlign: TextAlign.center),
              ],
            ),
          );
        }
      });
}

/// ListView of TaskCards of Tasks in attribute tasks in [courseList]. [doneNotDone] null if no filter
/// is needed, true if Task.done == true and false if Task.done == false
ListView tasksListView(List<Course> courseList, bool? doneNotDone) {
  List<Task> filteredTasks = [];
  for (var ct in courseList) {
    if (ct.tasks.isNotEmpty) {
      if (doneNotDone != null) {
        filteredTasks.addAll(ct.tasks.where((tsk) => tsk.done == doneNotDone));
      } else {
        filteredTasks.addAll(ct.tasks);
      }
    }
  }

  Map<String, String> courseRefs = {};
  for (var course in courseList) {
    courseRefs[course.id!] = course.title;
  }

  return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        if (filteredTasks.isNotEmpty) {
          return Column(
              children: filteredTasks.map((task) {
            return TaskCard(
              checkboxFunction: (bool value, context) {
                context.read<TasksScreenBloc>().add(
                      CheckboxChangedEvent(
                        courseId: courseRefs[task.courseRef] ?? '',
                        taskId: task.id,
                        isChecked: value,
                      ),
                    );
              },
              task: task,
              isChecked: task.done,
              courseId: courseRefs[task.courseRef] ?? '',
            );
          }).toList());
        } else {
          String message = '';

          if (doneNotDone == null) {
            message = 'No tienes tareas asignadas.';
          } else if (doneNotDone == true) {
            message = 'No tienes tareas completadas.';
          } else if (doneNotDone == false) {
            message = 'No tienes tareas pendientes.';
          }

          return Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Column(
              children: [
                SizedBox(
                    width: 250.w, child: Image.asset('assets/images/free.png')),
                Text(message,
                    style: TothemTheme.bodyText, textAlign: TextAlign.center),
              ],
            ),
          );
        }
      });
}
