import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/course_category.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tothem/src/screens/course_details/course_details_screen.dart';

import 'package:tothem/src/screens/desk/desk.dart';

class DeskScreen extends StatelessWidget {
  const DeskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const TothemBottomAppBar(),
        appBar: standardAppBar(const Text('Mi escritorio')),
        body: BlocBuilder<DeskBloc, DeskState>(builder: (context, state) {
          return LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                      padding:
                          EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cursos creados', style: TothemTheme.title),
                          ButtonBar(
                            children: [
                              // getGreenIconButton(context, () {}, Icons.search,
                              //     TothemTheme.rybGreen),
                              getGreenIconButton(context, () {
                                showAddCourseDialog(context,
                                    state.categoriesList!, state.authUser!);
                              }, Icons.add, TothemTheme.rybGreen)
                            ],
                          )
                        ],
                      ))
                ]),
              ),
              BlocBuilder<TeacherCourseBloc, TeacherCourseState>(
                  builder: (context, state) {
                if (state is TeacherCourseLoading) {
                  return SliverFillRemaining(
                    child: whiteBackgroundContainer(
                        const Center(child: CircularProgressIndicator())),
                  );
                } else if (state is TeacherCourseLoaded) {
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      state.courses.map((course) {
                        String categoryName = course.category;
                        if (state.categories.containsKey(course.category)) {
                          String catId = course.category;
                          categoryName =
                              state.categories[catId] ?? course.category;
                        }
                        return whiteBackgroundContainer(CourseCard(
                            key: key, course: course, category: categoryName));
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
            ]);
          });
        }));
  }
}

showAddCourseDialog(BuildContext context, List<CourseCategory> categoriesList,
    auth.User authUser) {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedCategory = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text("Crear curso", style: TothemTheme.dialogTitle),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Introduce un título.";
                    },
                    decoration: InputDecoration(
                        labelText: "Título del curso",
                        labelStyle: TothemTheme.dialogFields),
                  ),
                  DropdownButtonFormField(
                      isDense: true,
                      isExpanded: true,
                      validator: (value) {
                        return value != null
                            ? null
                            : "Selecciona una categoría.";
                      },
                      decoration: InputDecoration(
                          labelText: "Categoría",
                          labelStyle: TothemTheme.dialogFields),
                      items: categoriesList.map((CourseCategory category) {
                        return DropdownMenuItem<String>(
                          value: category.title,
                          child: SizedBox(
                              width: double.infinity,
                              child: Text(category.title,
                                  overflow: TextOverflow.clip)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedCategory = value ?? '';
                      }),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: null,
                    validator: (value) {
                      return value!.isNotEmpty
                          ? null
                          : "Introduce una descripción";
                    },
                    decoration: InputDecoration(
                        labelText: "Descripción",
                        labelStyle: TothemTheme.dialogFields),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text(
              "Crear",
              style: TothemTheme.buttonTextW,
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                try {
                  CourseCategory categoryObject = categoriesList.firstWhere(
                      (element) => element.title == selectedCategory);
                  Course newCourse = const Course().copyWith(
                      title: titleController.text,
                      description: descriptionController.text,
                      category: categoryObject.id,
                      createDate: DateTime.now());

                  context
                      .read<DeskBloc>()
                      .add(CreateCourseEvent(newCourse, authUser));

/*
NO DA TIEMPO A QUE SE CARGUE EL NUEVO CURSO EN EL ESTADO
                  // Navega a la pantalla de detalles del curso y pasa el curso seleccionado
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailsScreen(
                          course: context.read<DeskBloc>().state.course),
                    ),
                  );
                  */
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No se ha podido añadir el curso')),
                  );
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Curso añadido')),
                );
                Navigator.pop(context, 'Crear');
                // Navega a la pantalla de detalles del curso y pasa el curso seleccionado
              }
            },
          ),
        ],
      );
    },
  );
}
