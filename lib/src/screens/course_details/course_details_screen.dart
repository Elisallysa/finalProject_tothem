import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/course.dart';
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
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget._contents.length,
                  itemBuilder: (context, index) {
                    return _buildList(widget._contents[index]);
                  },
                ),
                ListView.builder(
                  itemCount: 25,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTile(
                      backgroundColor: index.isOdd
                          ? Colors.deepOrange
                          : Colors.lightBlueAccent,
                      title: Text('eo $index'),
                      subtitle: const Text('un subtitulo'),
                      children: [
                        const Text(
                          'Los hijos del expandable',
                          textAlign: TextAlign.justify,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Texto dentro de un contenedor'),
                        )
                      ],
                    );
                  },
                ),
                ListView.builder(
                  itemCount: 25,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      tileColor: index.isOdd ? Colors.brown : Colors.redAccent,
                      title: Text('waraseo $index'),
                    );
                  },
                ),
              ],
            ),
          );
        } else if (state is CourseError) {
          return Scaffold(
              appBar: AppBar(title: const Text('Curso no encontrado')),
              bottomNavigationBar: TothemBottomAppBar(key: widget.key),
              body: whiteBackgroundContainer(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                        width: 250.w,
                        child: Image.asset('assets/images/notfound.png')),
                    Text('No se ha podido encontrar el curso seleccionado.',
                        style: TothemTheme.bodyText,
                        textAlign: TextAlign.center),
                  ],
                ),
              )));
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

Widget _buildList(Content content) {
  /* if (content) {
      return Builder(
        builder: (context) {
          return ListTile(
              onTap:() => Navigator.push(context, MaterialPageRoute(builder: (context) => SubCategory(list.name))),
              leading: const SizedBox(),
              title: Text(list.name)
          );
        }
      );
    }
   */
  return ExpansionTile(
    leading: const Icon(Tothem.trash),
    title: Text(content.title, style: TothemTheme.tileTitle),
    children: [Text(content.description, style: TothemTheme.tileDescription)],
  );
}
