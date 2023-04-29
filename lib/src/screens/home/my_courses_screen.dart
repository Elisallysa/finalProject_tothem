import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/screens/home/my_courses.dart';

class MyCoursesScreen extends StatelessWidget {
  final String? userName;
  final String? userLastName;
  final String? userRole;

  const MyCoursesScreen(
      {Key? key, this.userName, this.userLastName, this.userRole})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const TothemBottomAppBar(),
      backgroundColor: TothemTheme.rybGreen,
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return CustomScrollView(
              slivers: <Widget>[
                customSliverAppBar(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: [
                          profilePictureHeader(),
                          UserInfoContainer(
                              userName: userName,
                              userLastName: userLastName,
                              userRole: userRole),
                          whiteBackgroundContainer(
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mis cursos',
                                    style: TothemTheme.title,
                                  ),
                                  ButtonBar(
                                    children: [
                                      getGreenIconButton(context, () {},
                                          Icons.search, TothemTheme.rybGreen),
                                      getGreenIconButton(context, () {},
                                          Icons.add, TothemTheme.rybGreen)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => whiteBackgroundContainer(
                            CourseCard(
                              key: key,
                            ),
                          ),
                      childCount: 2),
                )
                /*
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
                */
              ],
            );
          },
        );
      }),
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
