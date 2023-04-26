import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/screens/my_courses/my_courses.dart';
import 'package:tothem/src/screens/my_courses/widgets/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: TothemTheme.rybGreen,
      extendBodyBehindAppBar: false,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) =>
            [getScrollableAppBar()],
        body:
            Stack(children: <Widget>[getHomeHeader(), getContentArea(context)]),
      ),
    ));
  }
}
