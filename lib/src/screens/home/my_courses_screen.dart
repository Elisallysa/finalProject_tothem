import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/screens/home/my_courses.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const TothemBottomAppBar(),
      backgroundColor: TothemTheme.rybGreen,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return CustomScrollView(
            slivers: <Widget>[
              customSliverAppBar(),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    profilePictureHeader(),
                    BodyWidget(Colors.red),
                    BodyWidget(Colors.green),
                    BodyWidget(Colors.orange),
                    BodyWidget(Colors.transparent),
                    BodyWidget(Colors.red),
                  ],
                ),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                    ),
                    BodyWidget(Colors.transparent),
                    BodyWidget(Colors.yellow),
                    BodyWidget(Colors.orange),
                    BodyWidget(Colors.blue),
                    BodyWidget(Colors.red),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String text;

  HeaderWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text('jadfas'),
      color: Colors.grey[200],
    );
  }
}

class BodyWidget extends StatelessWidget {
  final Color color;

  BodyWidget(this.color);

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
