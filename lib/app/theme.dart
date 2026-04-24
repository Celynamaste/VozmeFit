import 'package:flutter/material.dart';

// Colores corporativos VozmeFit
const Color _aquaBlue = Color(0xFF00B4D8);       // Azul agua principal
const Color _aquaBluLight = Color(0xFF48CAE4);    // Azul agua claro (acento)
const Color _black = Color(0xFF080808);           // Negro de fondo
const Color _surface = Color(0xFF141414);         // Negro de tarjetas y AppBar
const Color _white = Color(0xFFF0F0F0);           // Blanco para texto principal
const Color _grey = Color(0xFF9E9E9E);            // Gris para texto secundario

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: _black,
  primaryColor: _aquaBlue,

  colorScheme: const ColorScheme.dark(
    primary: _aquaBlue,
    secondary: _aquaBluLight,
    surface: _surface,
    onPrimary: Colors.white,
    onSurface: _white,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: _surface,
    foregroundColor: _white,
    titleTextStyle: TextStyle(
      color: _white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
    iconTheme: IconThemeData(color: _aquaBlue),
    elevation: 0,
    shape: Border(
      bottom: BorderSide(color: _aquaBlue, width: 1),
    ),
  ),

  cardTheme: const CardTheme(
    color: _surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      side: BorderSide(color: Color(0xFF222222), width: 1),
    ),
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: _white),
    bodyLarge: TextStyle(color: _white),
    bodySmall: TextStyle(color: _grey),
    titleLarge: TextStyle(
      color: _white,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    titleMedium: TextStyle(
      color: _white,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF333333)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF333333)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _aquaBlue, width: 2),
    ),
    labelStyle: const TextStyle(color: _grey),
    hintStyle: const TextStyle(color: _grey),
    prefixIconColor: _aquaBlue,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _aquaBlue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _aquaBlue,
      side: const BorderSide(color: _aquaBlue),
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

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _aquaBlue,
    ),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _aquaBlue,
    foregroundColor: Colors.white,
  ),

  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return _aquaBlue;
      return Colors.transparent;
    }),
    side: const BorderSide(color: _grey),
  ),

  dividerTheme: const DividerThemeData(
    color: Color(0xFF222222),
    thickness: 1,
  ),
);

