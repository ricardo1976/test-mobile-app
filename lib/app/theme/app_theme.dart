import 'package:flutter/material.dart';

abstract final class AppPalette {
  static const ink = Color(0xFF202B3C);
  static const paper = Color(0xFFF7F2E8);
  static const coral = Color(0xFFE8755C);
  static const teal = Color(0xFF317C72);
  static const mustard = Color(0xFFE9BC55);
  static const mutedInk = Color(0xFF667080);
}

abstract final class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPalette.teal,
      primary: AppPalette.teal,
      secondary: AppPalette.coral,
      surface: AppPalette.paper,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppPalette.paper,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppPalette.ink,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -1.2,
      ),
      titleLarge: TextStyle(color: AppPalette.ink, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(color: AppPalette.mutedInk, height: 1.5),
      bodyMedium: TextStyle(color: AppPalette.mutedInk, height: 1.4),
    ),
  );
}
