import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';
import 'package:tothem/src/models/task.dart';
import 'package:tothem/src/screens/course_details/bloc/course_details_bloc.dart';
import 'package:tothem/src/screens/course_details/bloc/course_details_event.dart';

class TaskCard extends StatelessWidget {
  final String courseId;
  final Task task;
  final bool isChecked;
  final Function checkboxFunction;

  const TaskCard(
      {Key? key,
      required this.courseId,
      required this.task,
      required this.isChecked,
      required this.checkboxFunction})
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
              trailing: Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isChecked,
                  onChanged: (bool? value) {
                    final event = CheckboxChangedEvent(
                        courseId: courseId,
                        isChecked: value ?? false,
                        taskId: task.id);
                    BlocProvider.of<CourseDetailsBloc>(context).add(event);
                  }),
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
                  children: const [
                    Text('Apertura: 17 de junio 2023'),
                    Text('Cierre: 9 de julio 2023')
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
