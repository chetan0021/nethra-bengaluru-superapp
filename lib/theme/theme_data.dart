import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

/// Nethra App Theme Configuration
class NethraTheme {
  /// Main dark theme with cyberpunk aesthetics
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: NethraPalette.neonCyan,
    scaffoldBackgroundColor: NethraPalette.deepIndigo,
    colorScheme: const ColorScheme.dark(
      primary: NethraPalette.neonCyan,
      secondary: NethraPalette.electricPurple,
      surface: NethraPalette.darkSlate,
      onPrimary: NethraPalette.deepIndigo,
      onSecondary: NethraPalette.softWhite,
      onSurface: NethraPalette.softWhite,
    ),
    textTheme: NethraTextTheme.textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: NethraPalette.neonCyan,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: NethraPalette.neonCyan,
        foregroundColor: NethraPalette.deepIndigo,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: NethraPalette.neonCyan,
      foregroundColor: NethraPalette.deepIndigo,
      elevation: 8,
    ),
    cardTheme: CardThemeData(
      color: NethraPalette.darkSlate.withOpacity(0.3),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: NethraPalette.glassBorder,
          width: 1,
        ),
      ),
    ),
  );

  /// High contrast theme for blind mode
  static ThemeData get highContrastTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: NethraPalette.highContrastText,
    scaffoldBackgroundColor: NethraPalette.highContrastBg,
    colorScheme: const ColorScheme.dark(
      primary: NethraPalette.highContrastText,
      secondary: NethraPalette.highContrastText,
      surface: NethraPalette.highContrastBg,
      onPrimary: NethraPalette.highContrastBg,
      onSecondary: NethraPalette.highContrastBg,
      onSurface: NethraPalette.highContrastText,
    ),
    textTheme: NethraTextTheme.highContrastTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: NethraPalette.highContrastBg,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: NethraPalette.highContrastText,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: NethraPalette.highContrastText,
        foregroundColor: NethraPalette.highContrastBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    ),
    cardTheme: const CardThemeData(
      color: NethraPalette.highContrastBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(
          color: NethraPalette.highContrastText,
          width: 2,
        ),
      ),
    ),
  );
}