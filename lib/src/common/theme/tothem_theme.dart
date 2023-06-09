import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Theme, colors and fonts used in tothem App.
class TothemTheme {
  TothemTheme._();

  // ThemeData
  //Not used
  static ThemeData getTothemTheme() {
    return ThemeData(
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: kellyGreen,
            onPrimary: Colors.white,
            secondary: brinkPink,
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            background: Colors.white,
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black),
        fontFamily: openSansFont);
  }

  static ThemeData getSeedTheme() {
    return ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: rybGreen,
        iconButtonTheme: const IconButtonThemeData(
            style: ButtonStyle(
                iconColor: MaterialStatePropertyAll(rybGreen),
                surfaceTintColor: MaterialStatePropertyAll(brinkPink))),
        iconTheme: const IconThemeData(color: TothemTheme.rybGreen),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: OutlinedButton.styleFrom(
                backgroundColor: TothemTheme.brinkPink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 10.h,
                shadowColor: const Color.fromARGB(255, 128, 36, 105),
                fixedSize: const Size(double.maxFinite, 50),
                textStyle: TothemTheme.buttonTextW)),
        primaryIconTheme: const IconThemeData(color: Colors.yellow),
        tabBarTheme: TabBarTheme(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: darkGreen.withOpacity(0.5)),
        appBarTheme: AppBarTheme(
            titleTextStyle: whiteHeader,
            backgroundColor: TothemTheme.rybGreen,
            iconTheme: const IconThemeData(color: Colors.white)),
        bottomAppBarTheme: const BottomAppBarTheme(color: rybGreen),
        useMaterial3: true,
        fontFamily: openSansFont);
  }

  // MAIN COLOR VARIATIONS: LIME
  static const Color tothemLime = Color.fromRGBO(16, 211, 39, 1);
  static const Color shadowLime = Color.fromRGBO(104, 145, 8, 1);
  static const Color darkerLime = Color.fromRGBO(110, 151, 12, 1);

  // ACCENT COLOR VARIATIONS: PINK
  static const Color accentPink = Color.fromRGBO(255, 74, 118, 1);

  // AUX COLORS
  static const Color silver = Color.fromRGBO(155, 161, 171, 1);
  static const Color lightGrey = Color.fromRGBO(241, 246, 247, 1);
  static const Color darkBlue = Color.fromRGBO(29, 43, 71, 1);
  static const Color darkGreen = Color.fromRGBO(36, 65, 16, 1);

  // Green and pink palette
  static const Color salmonPink = Color.fromRGBO(255, 145, 164, 1);
  static const Color brinkPink = Color.fromRGBO(251, 96, 127, 1);
  static const Color palePink = Color.fromRGBO(250, 218, 221, 1);
  static const Color dollarBill = Color.fromRGBO(131, 199, 96, 1);
  static const Color rybGreen = Color.fromRGBO(102, 176, 50, 1);
  static const Color kellyGreen = Color.fromRGBO(78, 162, 23, 1);
  static const Color lightGreen = Color.fromRGBO(243, 255, 235, 1);

  // TEXT FONTS AND STYLES
  static String? openSansFont = GoogleFonts.openSans().fontFamily;
  static TextStyle title = GoogleFonts.openSans(
      color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700);
  static TextStyle smallTitle = GoogleFonts.openSans(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600);
  static TextStyle whiteHeader =
      GoogleFonts.openSans(color: Colors.white, fontSize: 20);
  static TextStyle whiteTitle = GoogleFonts.openSans(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle whiteSubtitleOpacity = GoogleFonts.openSans(
      color: Colors.white.withOpacity(0.8),
      fontSize: 14,
      fontWeight: FontWeight.w400);
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
  static TextStyle dialogTitle = GoogleFonts.openSans(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600);
  static TextStyle dialogFields = GoogleFonts.openSans(
      color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400);
  static TextStyle tileTitle = GoogleFonts.openSans(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600);
  static TextStyle tileDescription = GoogleFonts.openSans(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600);
  static TextStyle descriptionTitle = GoogleFonts.openSans(
      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600);
}
