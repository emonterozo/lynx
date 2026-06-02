import 'package:flutter/material.dart';

class LynxTheme {
  static const Color background = Color(0xFF0F172A);
  static const Color foreground = Color(0xFFF1F5F9);
  static const Color primary = Color(0xFFF97316);
  static const Color secondary = Color(0xFF64748B);
  static const Color mutedForeground = Color(0xFF94A3B8);
  static const Color card = Color(0xFF1E293B);
  static const Color border = Color(0xFF334155);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);


  static const String fontFamily = 'Poppins';

  static ThemeData darkTheme = ThemeData(
    fontFamily: fontFamily,
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: background,
      onSurface: foreground,
      outline: border,
    ),

    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: primary, width: 2),
      ),
      hintStyle: const TextStyle(color: mutedForeground),
    ),
  );
}
