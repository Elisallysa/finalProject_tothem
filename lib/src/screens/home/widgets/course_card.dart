import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';

class CourseCard extends StatelessWidget {
  final String heading = 'Título del Curso';
  final String subheading = 'Área de conocimiento';
  final String teacherName = 'Formador Apellido';
  final String? imagePath = 'https://source.unsplash.com/random/800x600?house';
  final String courseDescription = 'This is the course description...';

  const CourseCard({Key? key}) : super(key: key);

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
                    child: Image.network(
                      'https://img.freepik.com/foto-gratis/textura-pared-estuco-azul-marino-relieve-decorativo-abstracto-grunge-fondo-color-rugoso-gran-angular_1258-28311.jpg',
                      fit: BoxFit.fill,
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
                            Text(subheading, style: TothemTheme.whiteSubitle),
                      ),
                      Text(teacherName.toUpperCase(),
                          style: TothemTheme.whiteSubitle),
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
