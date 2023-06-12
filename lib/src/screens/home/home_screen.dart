import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tothem/src/common/widgets/message_snackbar.dart';
import 'package:tothem/src/repository/bloc/bloc.dart';
import 'package:tothem/src/screens/home/home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> categoriesMap = {
      'AE': 'Educación Alternativa',
      'AS': 'Estudios Artísticos',
      'LL': 'Idiomas',
      'PE': 'Educación Física',
      'SS': 'Asignatura Escolar',
      'SD': 'Desarrollo personal',
      'TR': 'Formación de empresa',
      'US': 'Asignatura Universitaria',
      'VE': 'Formación Profesional'
    };

    return Scaffold(
        bottomNavigationBar: const TothemBottomAppBar(),
        backgroundColor: TothemTheme.rybGreen,
        body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          return LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return CustomScrollView(
                slivers: <Widget>[
                  customSliverAppBar(),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Column(
                          children: [
                            profilePictureHeader(
                                state.authUser?.photoURL ?? ''),
                            UserInfoContainer(
                                userName: state.authUser != null
                                    ? state.authUser!.displayName!
                                    : 'Tu Nombre',
                                userLastname: '',
                                userRole: state.user?.role ?? ''),
                            whiteBackgroundContainer(
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10.h, left: 10.w, right: 10.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Mis cursos',
                                      style: TothemTheme.title,
                                    ),
                                    ButtonBar(
                                      children: [
                                        /*
                                        getGreenIconButton(context, () {},
                                            Icons.search, TothemTheme.rybGreen), */
                                        getGreenIconButton(context, () {
                                          _showJoinCourseDialog(
                                              context, state.authUser!);
                                        }, Icons.add, TothemTheme.rybGreen)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<CourseBloc, CourseState>(
                      builder: (context, state) {
                    if (state is CourseLoading) {
                      return SliverFillRemaining(
                        child: whiteBackgroundContainer(
                            const Center(child: CircularProgressIndicator())),
                      );
                    } else if (state is CourseLoaded) {
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          state.courses.map((course) {
                            return whiteBackgroundContainer(CourseCard(
                                key: key,
                                category: categoriesMap[course.category] ??
                                    course.category,
                                course: course));
                          }).toList(),
                        ),
                      );
                    } else {
                      return SliverFillRemaining(
                        child: whiteBackgroundContainer(
                            const Center(child: Text('Error inesperado.'))),
                      );
                    }
                  })

                  /*
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                    ),
                    BodyWidget(Colors.transparent),
                    BodyWidget(Colors.yellow),
                    BodyWidget(Colors.orange),
                    BodyWidget(Colors.blue),
                    BodyWidget(Colors.red),
                  ],
                ),
              ),
              */
                ],
              );
            },
          );
        }));
  }
}

void _showJoinCourseDialog(BuildContext context, auth.User user) {
  final codeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  showAlertSnackbar(String message, String buttonText, Function? buttonAction) {
    ScaffoldMessenger.of(context)
        .showSnackBar(alertSnackbar(message, buttonText, buttonAction));
  }

  joinCourse(String code) {
    context.read<CourseBloc>().add(JoinCourse(user: user, courseCode: code));
  }

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unirme a un curso'),
          content: SingleChildScrollView(
              child: ListBody(
            children: [
              const Text(
                  'Pídele el código a tu profesor/a o formador/a e introdúcelo en el campo de texto.'),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: codeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Introduce un código.';
                    } else if (value.length != 6) {
                      return 'Código no válido.';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Código del curso",
                      labelStyle: TothemTheme.dialogFields),
                ),
              ),
            ],
          )),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancelar'),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    if (await _checkCourseCodeExists(codeController.text)) {
                      try {
                        joinCourse(codeController.text);
                      } catch (e) {
                        if (e.toString().contains("Already")) {
                          showAlertSnackbar(
                              'Ya estás registrado en este curso.', 'OK', null);
                        } else if (e.toString().contains("join")) {
                          showAlertSnackbar(
                              'No se ha podido efectuar el registro.',
                              'OK',
                              null);
                        } else {
                          showAlertSnackbar(
                              'Error al unirse al curso.', 'OK', null);
                        }
                      }
                    } else {
                      showAlertSnackbar(
                          'No hay un curso asociado a este código.',
                          'OK',
                          null);
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {}
                Navigator.pop(context, 'Unirse');
              },
              child: const Text('Unirse'),
            ),
          ],
        );
      });
}

Future<bool> _checkCourseCodeExists(String courseCode) async {
  return CourseRepository(firebaseFirestore: FirebaseFirestore.instance)
      .courseCodeExists(courseCode);
}
