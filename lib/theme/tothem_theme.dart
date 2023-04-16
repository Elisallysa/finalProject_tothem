import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TothemTheme {
  // Text fonts and styles and colors.
  TothemTheme._();

  // MAIN COLOR VARIATIONS: LIME
  static const Color tothemLime = Color.fromRGBO(16, 211, 39, 1);
  static const Color shadowLime = Color.fromRGBO(104, 145, 8, 1);
  static const Color darkerLime = Color.fromRGBO(110, 151, 12, 1);

  // ACCENT COLOR VARIATIONS: PINK
  static const Color accentPink = Color.fromRGBO(255, 74, 118, 1);

  // TEXT COLORS
  static const Color silver = Color.fromRGBO(155, 161, 171, 1);
  static const Color lightGrey = Color.fromRGBO(241, 246, 247, 1);

  // Green and pink palette
  static const Color salmonPink = Color.fromRGBO(255, 145, 164, 1);
  static const Color brinkPink = Color.fromRGBO(251, 96, 127, 1);
  static const Color palePink = Color.fromRGBO(250, 218, 221, 1);
  static const Color dollarBill = Color.fromRGBO(131, 199, 96, 1);
  static const Color rybGreen = Color.fromRGBO(102, 176, 50, 1);
  static const Color kellyGreen = Color.fromRGBO(78, 162, 23, 1);
  static const Color lightGreen = Color.fromRGBO(243, 255, 235, 1);

  // TEXT FONTS AND STYLES

  static TextStyle title = GoogleFonts.openSans(
      color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700);
  static TextStyle bodyText = GoogleFonts.openSans(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal);
  static TextStyle screenTitle = GoogleFonts.openSans(
      color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500);
  static TextStyle silverText = GoogleFonts.openSans(
      color: silver, fontSize: 14, fontWeight: FontWeight.normal);
  static TextStyle clickableText = GoogleFonts.openSans(
      color: darkerLime, fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle buttonTextW = GoogleFonts.openSans(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle buttonTextB = GoogleFonts.openSans(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle buttonTextP = GoogleFonts.openSans(
      color: brinkPink, fontSize: 14, fontWeight: FontWeight.w500);
}
