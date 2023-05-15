import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/screens/desk/desk.dart';

class DeskScreen extends StatelessWidget {
  const DeskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              getGreenIconButton(context, () {}, Icons.search,
                                  TothemTheme.rybGreen),
                              getGreenIconButton(context, () {
                                showAddCourseDialog(context);
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
                        return whiteBackgroundContainer(CourseCard(
                            key: key,
                            heading: course.title,
                            subheading: course.category,
                            teacherName: course.teacher,
                            courseDescription: course.description));
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

showAddCourseDialog(BuildContext context) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text("Crear curso", style: TothemTheme.dialogTitle),
        content: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      labelText: "Título del curso",
                      labelStyle: TothemTheme.dialogFields),
                ),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: "Categoría",
                        labelStyle: TothemTheme.dialogFields),
                    items: [],
                    onChanged: null),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: "Descripción",
                      labelStyle: TothemTheme.dialogFields),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            child: const Text("Crear"),
            onPressed: () {
              // your code
            },
          ),
        ],
      );
    },
  );
}
