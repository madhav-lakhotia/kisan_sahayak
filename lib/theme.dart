import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const yellow = Color(0xFFF6C667);
  static const yellowDark = Color(0xFFFFB74D);
  static const yellowLight = Color(0xFFFFE5A0);
  static const bg = Color(0xFFFDF7E4);
  static const textDark = Color(0xFF2B2929);
}

ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.bg,
  primaryColor: AppColors.yellow,
  textTheme: GoogleFonts.notoSansDevanagariTextTheme(),

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.yellow,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.notoSansDevanagari(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textDark,
    ),
  ),

  // ✔ Correct for Flutter 3.38
  cardTheme: const CardThemeData(
    color: AppColors.yellowLight,
    margin: EdgeInsets.all(8),
  ),
);
