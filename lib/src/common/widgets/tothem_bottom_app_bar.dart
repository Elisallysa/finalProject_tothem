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
                Icons.home_outlined,
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
                Icons.school_outlined,
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
              icon: Icon(Icons.list_alt, color: iconColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.calendar_month_outlined, color: iconColor),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.person_2_outlined,
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
