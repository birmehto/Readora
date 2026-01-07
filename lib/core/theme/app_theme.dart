import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF006A6A),
      surface: const Color(0xFFF8FAF9),
      primary: const Color(0xFF006A6A),
      secondary: const Color(0xFF4A6363),
      tertiary: const Color(0xFF4B6078),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAF9),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.w900),
      displayMedium: TextStyle(fontWeight: FontWeight.w900),
      displaySmall: TextStyle(fontWeight: FontWeight.w800),
      headlineLarge: TextStyle(fontWeight: FontWeight.w800),
      headlineMedium: TextStyle(fontWeight: FontWeight.w800),
      headlineSmall: TextStyle(fontWeight: FontWeight.w700),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(color: Color(0x1A000000)),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF0F4F3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF006A6A),
      brightness: Brightness.dark,
      surface: const Color(0xFF0A0F0F), // Deeper dark
      primary: const Color(0xFF4DB6AC), // Brighter teal for dark mode
      secondary: const Color(0xFFB0CCCC),
      tertiary: const Color(0xFFB4C8E8),
    ),
    scaffoldBackgroundColor: const Color(0xFF0A0F0F),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
      displayMedium: TextStyle(
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
      displaySmall: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(color: Color(0x1AFFFFFF)),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF141A1A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
    ),
  );
}
