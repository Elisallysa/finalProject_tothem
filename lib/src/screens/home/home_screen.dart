import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/screens/home/home.dart';

class HomeScreen extends StatelessWidget {
  final String? userName;
  final String? userLastName;
  final String? userRole;

  const HomeScreen({Key? key, this.userName, this.userLastName, this.userRole})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const TothemBottomAppBar(),
        backgroundColor: TothemTheme.rybGreen,
        body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          return LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return CustomScrollView(
                slivers: <Widget>[
                  customSliverAppBar(),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Column(
                          children: [
                            profilePictureHeader(
                                state.authUser?.photoURL ?? ''),
                            UserInfoContainer(
                                userName: state.authUser != null
                                    ? state.authUser!.displayName!
                                    : 'eo',
                                userLastname: '',
                                userRole: state.user?.role ?? ''),
                            whiteBackgroundContainer(
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10.h, left: 10.w, right: 10.w),
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
                  BlocBuilder<CourseBloc, CourseState>(
                      builder: (context, state) {
                    if (state is CourseLoading) {
                      return SliverFillRemaining(
                        child: whiteBackgroundContainer(
                            const Center(child: CircularProgressIndicator())),
                      );
                    } else if (state is CourseLoaded) {
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          state.courses.map((category) {
                            return whiteBackgroundContainer(
                                CourseCard(key: key, heading: category.title));
                          }).toList(),
                        ),
                      );
                    } else {
                      return SliverFillRemaining(
                        child: whiteBackgroundContainer(
                            const Center(child: Text('Error inesperado.'))),
                      );
                    }
                  })

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
        }));
  }
}
