import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/screens/my_courses/my_courses.dart';

SliverAppBar customSliverAppBar() {
  /// Transparent AppBar in Home view.
  return SliverAppBar(
    backgroundColor: Colors.transparent,
    leading: const Icon(Tothem.chevronLeft),
    expandedHeight: 80.h,
    floating: true,
    snap: true,

    /*
    flexibleSpace: Stack(
      children: <Widget>[
        Positioned.fill(
            child: Image.network(
          "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
          fit: BoxFit.cover,
        ))
      ],
    ),
    */
  );
}

Stack profilePictureHeader() {
  /// Header containing the profile picture of the signed-in user.
  return Stack(alignment: Alignment.bottomCenter, children: [
    Container(
      alignment: Alignment.bottomCenter,
      height: 50.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50))),
    ),
    Align(
      child: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          image: DecorationImage(
            image: NetworkImage(
                'https://patientcaremedical.com/wp-content/uploads/2018/04/male-catheters.jpg'),
          ),
        ),
      ),
    ),
  ]);
}

class Student extends StatelessWidget {
  final Color color;

  Student(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80.0,
        color: color,
        alignment: Alignment.center,
        child: Card(
          color: Colors.white,
          child: Text('Terjadif'),
        ));
  }
}

// ------- WIDGETS I'M NOT CURRENTLY USING -----

Column getBackground(double headerHeight) {
  return Column(
    children: [
      Container(
        height: headerHeight,
        decoration: const BoxDecoration(color: TothemTheme.rybGreen),
      ),
      Expanded(
        flex: 1,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
          child: Align(
            alignment: const AlignmentDirectional(0, -1.35),
            child: Container(
              //margin: EdgeInsets.all(20),
              width: 400,
              height: 125,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://patientcaremedical.com/wp-content/uploads/2018/04/male-catheters.jpg'),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Column getContentContainer(BuildContext context, double headerHeight) {
  return Column(children: [
    Container(
      height: headerHeight,
      color: Color.fromRGBO(23, 22, 22, 0.2),
      width: MediaQuery.of(context).size.width * 0.8,
    ),
    Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: GridView.count(
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          crossAxisCount: 2,
          childAspectRatio: .90,
          children: List.generate(8, (_) {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[FlutterLogo(), Text('data')],
                ),
              ),
            );
          }),
        ),
      ),
    )
  ]);
}