import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';
import 'package:tothem/src/screens/desk/desk_screen.dart';
import 'package:tothem/src/screens/home/home_screen.dart';

class TothemBottomAppBar extends StatelessWidget {
  const TothemBottomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color iconColor = TothemTheme.silver;

    return BottomAppBar(
      elevation: 0,
      height: 60.h,
      color: Colors.white,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              alignment: Alignment.center,
              icon: Icon(
                Tothem.home_2,
                color: iconColor,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
            ),
            IconButton(
              icon: Icon(
                Tothem.chalkboardTeacher,
                color: iconColor,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DeskScreen()));
              },
            ),
            IconButton(
              icon: Icon(Tothem.tasks, color: iconColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Tothem.calendar, color: iconColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Tothem.userAlt,
                color: iconColor,
              ),
              color: iconColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
