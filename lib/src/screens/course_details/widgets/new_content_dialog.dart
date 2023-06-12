import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';
import 'package:tothem/src/models/content.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/course_category.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/screens/course_details/bloc/course_details_bloc.dart';
import 'package:tothem/src/screens/course_details/bloc/course_details_event.dart';
import 'package:tothem/src/screens/desk/bloc/desk_bloc.dart';
import 'package:tothem/src/screens/desk/bloc/desk_event.dart';

showEditContentDialog(BuildContext context, Content content, String courseId) {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedCategory = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text("Editar contenido", style: TothemTheme.dialogTitle),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: content.title,
                    controller: titleController,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Introduce un título.";
                    },
                    decoration: InputDecoration(
                        labelText: "Título",
                        labelStyle: TothemTheme.dialogFields),
                  ),
                  TextFormField(
                    initialValue: content.description,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: descriptionController,
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
              "Editar",
              style: TothemTheme.buttonTextW,
            ),
            onPressed: () {
              if (titleController.text != content.title ||
                  descriptionController.text != content.description) {
                try {
                  context.read<CourseDetailsBloc>().add(EditContents(
                      content.id, null,
                      courseId: courseId,
                      description: descriptionController.text,
                      title: titleController.text));
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No se ha podido añadir el contenido.')),
                  );
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contenido añadido.')),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),

          /*
          SizedBox(height: 10.h),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                // If the button is pressed, return green, otherwise blue
                if (states.contains(MaterialState.pressed)) {
                  return Colors.green;
                }
                return Colors.red;
              }),
            ),
            child: Text(
              "Eliminar contenido",
              style: TothemTheme.buttonTextW,
            ),
            onPressed: () {
              print('PRESSED');
            },
          ),
          */
        ],
      );
    },
  );
}

showNewContentDialog(
    BuildContext context, List<Content> contentList, Course courseToBeEdited) {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedCategory = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text("Nuevo contenido", style: TothemTheme.dialogTitle),
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
                        labelText: "Título",
                        labelStyle: TothemTheme.dialogFields),
                  ),
                  TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: descriptionController,
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
              "Añadir",
              style: TothemTheme.buttonTextW,
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                try {
                  context.read<CourseDetailsBloc>().add(EditContents(
                      null, contentList,
                      courseId: courseToBeEdited.id!,
                      description: descriptionController.text,
                      title: titleController.text));
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No se ha podido añadir el contenido.')),
                  );
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contenido añadido.')),
                );
                Navigator.pop(context);
                // Navega a la pantalla de detalles del curso y pasa el curso seleccionado
              }
            },
          )
        ],
      );
    },
  );
}

showNewTaskDialog(BuildContext context, String courseId, String contentId) {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final postDateController = TextEditingController();
  final dueDateController = TextEditingController();
  final urlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isURL(String text) {
    const pattern =
        r'^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*\/?$';
    final regExp = RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(text);
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Nueva tarea", style: TothemTheme.dialogTitle),
            IconButton(
                onPressed: () {
                  showInfoDialog(context);
                },
                icon: const Icon(Icons.info_outline))
          ],
        ),
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
                        labelText: "Título",
                        labelStyle: TothemTheme.dialogFields),
                  ),
                  TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: descriptionController,
                    validator: (value) {
                      return value!.isNotEmpty
                          ? null
                          : "Introduce una descripción";
                    },
                    decoration: InputDecoration(
                        labelText: "Descripción",
                        labelStyle: TothemTheme.dialogFields),
                  ),
                  TextFormField(
                      maxLines: null,
                      controller: postDateController,
                      validator: (value) {
                        return value!.isNotEmpty
                            ? null
                            : "Selecciona una fecha";
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today,
                              color: TothemTheme.rybGreen),
                          labelText: "Fecha de publicación"),
                      readOnly: true,
                      onTap: () async {
                        DateTime? postDate = await getSelectedDate(context);
                        if (postDate != null) {
                          postDateController.text = postDate.toString();
                        }
                      }),
                  TextFormField(
                      maxLines: null,
                      controller: dueDateController,
                      validator: (value) {
                        return value!.isNotEmpty
                            ? null
                            : "Selecciona una fecha";
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today,
                              color: TothemTheme.rybGreen),
                          labelText: "Fecha de finalización"),
                      readOnly: true,
                      onTap: () async {
                        DateTime? dueDate = await getSelectedDate(context);
                        if (dueDate != null) {
                          dueDateController.text = dueDate.toString();
                        }
                      }),
                  TextFormField(
                    controller: urlController,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        List<String> urls = value.split(';');
                        for (var url in urls) {
                          if (!url.isURL) {
                            return 'No has introducido URL correcta(s)';
                          }
                        }
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "URLs",
                        labelStyle: TothemTheme.dialogFields),
                  )
                ],
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text(
              "Añadir",
              style: TothemTheme.buttonTextW,
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                DateTime createDate = DateTime.now();
                DateTime postDate = DateTime.parse(postDateController.text);
                DateTime dueDate = DateTime.parse(dueDateController.text);
                List<String> attachments = <String>[];

                if (urlController.text.isNotEmpty) {
                  attachments = urlController.text.split(';');
                }

                Task newTask = Task(
                    courseRef: courseId,
                    title: titleController.text,
                    description: descriptionController.text,
                    dueDate: dueDate,
                    postDate: postDate,
                    createDate: createDate,
                    attachments: attachments);

                try {
                  context.read<CourseDetailsBloc>().add(EditTasks(
                        task: newTask,
                        contentId: contentId,
                      ));
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No se ha podido añadir el contenido.')),
                  );
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tarea añadida.')),
                );
              }
            },
          )
        ],
      );
    },
  );
}

Future<DateTime?> getSelectedDate(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
      locale: const Locale('es', null),
      context: context,
      initialDate: DateTime.now(), //get today's date
      firstDate: DateTime(
          2000), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2101));

  if (pickedDate != null) {
    print(pickedDate);
    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
    print(formattedDate);
    return pickedDate;
  } else {
    return null;
  }
}

showInfoDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Archivos adjuntos"),
      content: const Text(
          "Copia la(s) URL a tu(s) archivo(s) en Google Drive separadas por punto y coma (;)."),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
