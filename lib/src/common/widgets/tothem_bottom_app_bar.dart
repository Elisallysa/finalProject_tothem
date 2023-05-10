import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tothem/src/common/assets/tothem_icons.dart';
import 'package:tothem/src/common/theme/tothem_theme.dart';

class TothemBottomAppBar extends StatelessWidget {
  const TothemBottomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color iconColor = TothemTheme.silver;

    return BottomAppBar(
      height: 50.h,
      elevation: 0,
      notchMargin: 5.0,
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Tothem.home,
            color: iconColor,
          ),
          Icon(
            Icons.school_outlined,
            color: iconColor,
          ),
          Icon(
            Tothem.list,
            color: iconColor,
          ),
          Icon(
            Tothem.calendar_1,
            color: iconColor,
          ),
          Icon(
            Tothem.user_1,
            color: iconColor,
          ),
        ],
      ),
    );
  }
}
