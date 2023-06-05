import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/models/course_category.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tothem/src/screens/desk/bloc/desk_bloc.dart';
import 'package:tothem/src/screens/desk/bloc/desk_event.dart';

showEditContentDialog(BuildContext context) {
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
              "Editar",
              style: TothemTheme.buttonTextW,
            ),
            onPressed: () {
              print('PRESSED');
            },
          ),
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
        ],
      );
    },
  );
}
