import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tothem/theme/tothem_theme.dart';

toastInfo(
    {required String msg,
    Color backgroundColor = TothemTheme.brinkPink,
    Color textColor = Colors.white}) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.sp);
}
