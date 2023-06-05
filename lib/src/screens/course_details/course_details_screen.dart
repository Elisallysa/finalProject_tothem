import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/screens/course_details/widgets/new_content_dialog.dart';
import 'package:tothem/src/screens/course_details/widgets/task_card.dart';
import 'package:tothem/src/screens/desk/desk.dart';
import 'package:tothem/src/screens/course_details/bloc/course_details_state.dart';

class CourseDetailsScreen extends StatefulWidget {
  Course _course;
  auth.User? _authUser;
  List<Content> _contents;

  CourseDetailsScreen(
      {Key? key, Course? course, auth.User? authUser, List<Content>? contents})
      : _course = course ?? const Course(id: 'aerodriguez420230520TRANTI'),
        _authUser = authUser ?? auth.FirebaseAuth.instance.currentUser,
        _contents = contents ??
            [
              const Content(
                  id: 'cont1',
                  title: 'Título de prueba',
                  description: 'Descripción del contenido de prueba',
                  attachments: ['un archivo adjunto'])
            ],
        super(key: key);

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<CourseDetailsBloc>(context)
          .add(CourseLoading(widget._course));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocBuilder<CourseDetailsBloc, CourseDetailsState>(
          builder: (context, state) {
        if (state is CourseLoaded) {
          return Scaffold(
            bottomNavigationBar: TothemBottomAppBar(key: widget.key),
            appBar: AppBar(
              title: Text(state.course.title),
              // This check specifies which nested Scrollable's scroll notification
              // should be listened to.
              //
              // When `ThemeData.useMaterial3` is true and scroll view has
              // scrolled underneath the app bar, this updates the app bar
              // background color and elevation.
              //
              // This sets `notification.depth == 1` to listen to the scroll
              // notification from the nested `ListView.builder`.
              notificationPredicate: (ScrollNotification notification) {
                return notification.depth == 1;
              },
              // The elevation value of the app bar when scroll view has
              // scrolled underneath the app bar.
              scrolledUnderElevation: 4.0,
              shadowColor: Theme.of(context).shadowColor,
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.content_paste),
                    text: 'Contenidos',
                  ),
                  Tab(
                    icon: Icon(Tothem.tasks),
                    text: 'Tareas',
                  ),
                  Tab(
                    icon: Icon(Tothem.users),
                    text: 'Personas',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                ListView.builder(
                  itemCount: state.contents.length,
                  itemBuilder: (context, index) {
                    if (state.contents.isNotEmpty) {
                      return _buildList(
                          context, state.contents[index], state.course.id!);
                    } else {
                      return whiteBackgroundContainer(
                        Column(
                          children: [
                            SizedBox(
                                width: 250.w,
                                child: Image.asset('assets/images/relax.png')),
                            Text('Este curso no tiene contenidos.',
                                style: TothemTheme.bodyText,
                                textAlign: TextAlign.center),
                          ],
                        ),
                      );
                    }
                  },
                ),
                ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    if (state.tasks.isNotEmpty) {
                      return Column(
                          children: state.tasks.map((task) {
                        return TaskCard(
                          checkboxFunction: (bool value, context) {
                            context.read<CourseDetailsBloc>().add(
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
                                child: Image.asset('assets/images/free.png')),
                            Text('No tienes tareas asignadas.',
                                style: TothemTheme.bodyText,
                                textAlign: TextAlign.center),
                          ],
                        ),
                      );
                    }
                  },
                ),
                ListView.builder(
                  itemCount: state.students.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (state.students.isNotEmpty) {
                      return ListTile(
                        leading: const Icon(
                          Tothem.user,
                          color: TothemTheme.rybGreen,
                        ),
                        title: Text(state.students[index].name),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Column(
                          children: [
                            SizedBox(
                                width: 250.w,
                                child: Image.asset('assets/images/alone.png')),
                            Text('Aún no se ha registrado ningún estudiante.',
                                style: TothemTheme.bodyText,
                                textAlign: TextAlign.center),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
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
    );
  }
}

Widget _buildList(BuildContext context, Content content, String courseId) {
  return ExpansionTile(
    title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      IconButton(
          onPressed: () {
            showEditContentDialog(context);
          },
          icon: const Icon(Tothem.edit)),
      Text(content.title, style: TothemTheme.tileTitle)
    ]),
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        alignment: Alignment.centerLeft,
        child: Text(content.description, style: TothemTheme.tileDescription),
      ),
      if (content.tasks.isNotEmpty)
        Column(
          children: content.tasks.map((task) {
            return TaskCard(
              checkboxFunction: (bool value, context) {
                context.read<CourseDetailsBloc>().add(CheckboxChangedEvent(
                    courseId: courseId, taskId: task.id, isChecked: value));
              },
              task: task,
              isChecked: task.done,
              courseId: courseId,
            );
          }).toList(),
        )
    ],
  );
}
