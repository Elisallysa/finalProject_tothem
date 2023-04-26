import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/screens/my_courses/my_courses.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: MyCustomAppBar(
            height: kToolbarHeight * 4,
            appBar: AppBar(
              backgroundColor: TothemTheme.rybGreen,
              elevation: 0,
              leading: const Icon(Tothem.menu),
            ),
            color: Colors.transparent,
            bottomWidget: Container(
              //margin: EdgeInsets.all(20),
              width: double.infinity,
              height: 125.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://patientcaremedical.com/wp-content/uploads/2018/04/male-catheters.jpg'),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            )),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              child: Text('home'),
              height: 90,
              color: Colors.yellow,
            ),
            Container(
              child: Text('home'),
              height: 90,
              color: Colors.black,
            ),
            Container(
              child: Text('home'),
              height: 90,
              color: Colors.blue,
            ),
            Container(
              child: Text('home'),
              height: 90,
              color: Colors.orange,
            ),
            Container(
              child: Text('home'),
              height: 90,
              color: Colors.pink,
            ),
            Container(
              child: Text('home'),
              height: 90,
              color: Colors.purple,
            ),
          ],
        )),
      ),
    );
  }
}
