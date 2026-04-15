import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0D0D0D),
  primaryColor: const Color(0xFF7FEFE3),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF7FEFE3),
    secondary: Color(0xFFA6F7EE),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFFF2F2F2)),
    bodyLarge: TextStyle(color: Color(0xFFF2F2F2)),
    titleLarge: TextStyle(
      color: Color(0xFFF2F2F2),
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white10,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF7FEFE3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFA6F7EE), width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFFBFBFBF)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF7FEFE3),
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);
