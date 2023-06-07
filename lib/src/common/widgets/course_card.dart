import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';
import 'package:tothem/src/models/course.dart';
import 'package:tothem/src/screens/course_details/course_details_screen.dart';
import 'package:tothem/src/screens/tasks_screen/tasks_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    super.key,
    this.course = const Course(
        title: 'Título de prueba',
        category: 'Categoría',
        teacherName: 'Nombre del Profe',
        teacherPhoto: 'assets/images/greenpic.png',
        description: 'Descripción del curso.',
        imagePath: 'assets/images/coursebackground.png'),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4.0,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    color: Colors.amber,
                    height: 100.0,
                    width: double.maxFinite,
                    child: Image.asset(
                      course.imagePath.isNotEmpty
                          ? course.imagePath
                          : 'assets/images/coursebackground.png',
                      fit: BoxFit.cover,
                    )),
                ListTile(
                  title: Text(
                    course.title,
                    style: TothemTheme.whiteTitle,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(course.category,
                            style: TothemTheme.whiteSubtitle),
                      ),
                      Text(course.teacherName.toUpperCase(),
                          style: TothemTheme.whiteSubtitle),
                    ],
                  ),
                  trailing:
                      const Icon(Icons.more_vert_rounded, color: Colors.white),
                  minLeadingWidth: 15,
                  minVerticalPadding: 15,
                ),
              ],
            ),
            Stack(
                alignment: Alignment.centerRight,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.topLeft,
                    child: Text(course.description),
                  ),
                  Positioned(
                    top: -55,
                    right: 20,
                    child: Container(
                      height: 60.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _getImage(course.teacherPhoto)),
                      ),
                    ),
                  ),
                ]),
            ButtonBar(
              children: [
                Ink(
                  decoration: const ShapeDecoration(
                    color: TothemTheme.brinkPink,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove_red_eye_outlined,
                        color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CourseDetailsScreen(course: course)),
                      );
                    },
                  ),
                ),
                Ink(
                  decoration: const ShapeDecoration(
                    color: TothemTheme.brinkPink,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.checklist,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TasksScreen(course: course)),
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

ImageProvider<Object> _getImage(String imagePath) {
  if (imagePath.contains('http')) {
    return NetworkImage(imagePath);
  } else {
    if (imagePath.isEmpty) {
      imagePath = 'assets/images/greenpic.png';
    }
    return AssetImage(imagePath);
  }
}
