import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/screens/my_courses/my_courses.dart';
import 'package:tothem/src/screens/my_courses/widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double headerHeight = 120.h;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      body: Container(
        child: Stack(children: <Widget>[
          getBackground(headerHeight),
          getContentContainer(context, headerHeight)
        ]),
      ),
    )
        //NestedScrollView(
        //  headerSliverBuilder: (context, innerBoxIsScrolled) =>
        //      [getScrollableAppBar()],
        //  body:

        );
  }
}
