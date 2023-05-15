import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';

class CourseCard extends StatelessWidget {
  final String heading;
  final String subheading;
  final String teacherName;
  final String imagePath;
  final String courseDescription;

  const CourseCard(
      {super.key,
      this.heading = 'Título del curso',
      this.subheading = 'Área de conocimiento',
      this.teacherName = 'John Doe',
      this.imagePath = 'assets/images/coursebackground.png',
      this.courseDescription = 'Descripción del curso.'});

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
                      imagePath,
                      fit: BoxFit.cover,
                    )),
                ListTile(
                  title: Text(
                    heading,
                    style: TothemTheme.whiteTitle,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child:
                            Text(subheading, style: TothemTheme.whiteSubtitle),
                      ),
                      Text(teacherName.toUpperCase(),
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
                    child: Text(courseDescription),
                  ),
                  Positioned(
                    top: -40,
                    right: 20,
                    child: Container(
                      height: 60.h,
                      width: 60.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://patientcaremedical.com/wp-content/uploads/2018/04/male-catheters.jpg'),
                        ),
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
                    onPressed: () {/* ... */},
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
                    onPressed: () {/* ... */},
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
