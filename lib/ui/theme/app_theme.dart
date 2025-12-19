import 'package:flutter/material.dart';

class AppTheme {
  // Colors (The Ocean)
  static const Color deepBlue = Color(0xFF001F3F);
  static const Color teal = Color(0xFF39CCCC);
  static const Color aqua = Color(0xFF7FDBFF);

  // Functional Colors
  static const Color success = Color(0xFF2ECC40);
  static const Color error = Color(0xFFFF4136);
  static const Color neutral = Color(0xFFDDDDDD);

  // Text Styles
  static TextStyle get titleStyle => const TextStyle(
        fontFamily: 'Fredoka',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: aqua,
      );

  static TextStyle get buttonStyle => const TextStyle(
        fontFamily: 'Fredoka',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      );

  static TextStyle get bodyStyle => const TextStyle(
        fontFamily: 'Fredoka',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: neutral,
      );

  // Theme Data
  static ThemeData get themeData => ThemeData(
        primaryColor: deepBlue,
        scaffoldBackgroundColor: deepBlue,
        textTheme: TextTheme(
          headlineLarge: titleStyle,
          labelLarge: buttonStyle,
          bodyMedium: bodyStyle,
        ),
        colorScheme: const ColorScheme.dark(
          primary: teal,
          secondary: aqua,
          surface: deepBlue,
          error: error,
          onPrimary: Colors.white,
          onSecondary: deepBlue,
          onSurface: neutral,
          onError: Colors.white,
        ),
        useMaterial3: true,
      );
}

