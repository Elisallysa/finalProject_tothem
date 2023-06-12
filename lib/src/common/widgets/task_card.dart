import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/screens/course_details/bloc/course_details_bloc.dart'
    as cDeetsBl;
import 'package:tothem/src/screens/course_details/bloc/course_details_event.dart'
    as cDeetsEv;
import 'package:tothem/src/screens/tasks_screen/bloc/tasks_screen_bloc.dart'
    as tScBl;
import 'package:tothem/src/screens/tasks_screen/bloc/tasks_screen_event.dart'
    as tScEv;
import 'package:tothem/src/screens/tasks_screen/tasks_screen.dart';

class TaskCard extends StatelessWidget {
  final String courseId;
  final Task task;
  final bool isChecked;
  final Function checkboxFunction;
  final bool clickedOnTasksScreen;
  final bool isStudent;

  const TaskCard(
      {Key? key,
      required this.courseId,
      required this.task,
      required this.isChecked,
      required this.checkboxFunction,
      required this.clickedOnTasksScreen,
      required this.isStudent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return TothemTheme.brinkPink;
      }
      return TothemTheme.rybGreen;
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: TothemTheme.rybGreen,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Image.asset(
                'assets/images/task.png',
                height: 50.h,
                width: 50.w,
                fit: BoxFit.scaleDown,
              ),
              trailing: Visibility(
                visible: isStudent,
                child: Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    onChanged: (bool? value) {
                      if (clickedOnTasksScreen) {
                        final taskEvent = tScEv.CheckboxChangedEvent(
                            courseId: courseId,
                            isChecked: value ?? false,
                            taskId: task.id);
                        BlocProvider.of<tScBl.TasksScreenBloc>(context)
                            .add(taskEvent);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TasksScreen()),
                        );
                      } else {
                        final courseDeetsEvent = cDeetsEv.CheckboxChangedEvent(
                            courseId: courseId,
                            isChecked: value ?? false,
                            taskId: task.id);
                        BlocProvider.of<cDeetsBl.CourseDetailsBloc>(context)
                            .add(courseDeetsEvent);
                      }
                    }),
              ),
              title: Text(task.title, style: TothemTheme.tileTitle),
              subtitle:
                  Text(task.description, style: TothemTheme.tileDescription),
            ),
            Container(
              width: double.infinity,
              color: TothemTheme.lightGreen,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Apertura: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(getFormattedDate(task.postDate))
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Cierre: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(getFormattedDate(task.dueDate))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String getFormattedDate(DateTime date) {
  initializeDateFormatting('es_ES', null);

  String formattedDate = DateFormat.yMMMMd('es_ES').format(date);
  String time = DateFormat.Hm().format(date);

  return '$formattedDate $time';
}
