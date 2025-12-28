import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Typography system using Poppins font family
class NethraTypography {
  static const String fontFamily = 'Poppins';
  
  // Text Styles - Normal Mode
  static TextStyle get heading1 => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: NethraPalette.neonCyan,
    letterSpacing: -0.5,
  );
  
  static TextStyle get heading2 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: NethraPalette.softWhite,
    letterSpacing: -0.25,
  );
  
  static TextStyle get heading3 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: NethraPalette.softWhite,
  );
  
  static TextStyle get body => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: NethraPalette.softWhite,
    height: 1.5,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: NethraPalette.softWhite,
    height: 1.4,
  );
  
  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: NethraPalette.mutedGray,
    height: 1.3,
  );
  
  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: NethraPalette.deepIndigo,
    letterSpacing: 0.5,
  );
  
  // Accent Text Styles
  static TextStyle get neonText => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: NethraPalette.neonCyan,
  );
  
  static TextStyle get purpleText => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: NethraPalette.electricPurple,
  );
  
  // Accessibility - High Contrast Mode
  static TextStyle get highContrastHeading1 => GoogleFonts.poppins(
    fontSize: 38, // 20% larger
    fontWeight: FontWeight.w700,
    color: NethraPalette.highContrastText,
    letterSpacing: -0.5,
  );
  
  static TextStyle get highContrastHeading2 => GoogleFonts.poppins(
    fontSize: 29, // 20% larger
    fontWeight: FontWeight.w600,
    color: NethraPalette.highContrastText,
    letterSpacing: -0.25,
  );
  
  static TextStyle get highContrastBody => GoogleFonts.poppins(
    fontSize: 19, // 20% larger
    fontWeight: FontWeight.w400,
    color: NethraPalette.highContrastText,
    height: 1.5,
  );
  
  static TextStyle get highContrastCaption => GoogleFonts.poppins(
    fontSize: 14, // 20% larger
    fontWeight: FontWeight.w300,
    color: NethraPalette.highContrastText,
    height: 1.3,
  );
  
  // Chat-specific styles
  static TextStyle get chatUserMessage => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: NethraPalette.deepIndigo,
    height: 1.4,
  );
  
  static TextStyle get chatAssistantMessage => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: NethraPalette.softWhite,
    height: 1.4,
  );
  
  static TextStyle get chatTimestamp => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    color: NethraPalette.mutedGray,
  );
}

/// Text theme configuration for Flutter ThemeData
class NethraTextTheme {
  static TextTheme get textTheme => TextTheme(
    displayLarge: NethraTypography.heading1,
    displayMedium: NethraTypography.heading2,
    displaySmall: NethraTypography.heading3,
    bodyLarge: NethraTypography.body,
    bodyMedium: NethraTypography.bodyMedium,
    bodySmall: NethraTypography.caption,
    labelLarge: NethraTypography.button,
  );
  
  static TextTheme get highContrastTextTheme => TextTheme(
    displayLarge: NethraTypography.highContrastHeading1,
    displayMedium: NethraTypography.highContrastHeading2,
    displaySmall: NethraTypography.highContrastHeading2,
    bodyLarge: NethraTypography.highContrastBody,
    bodyMedium: NethraTypography.highContrastBody,
    bodySmall: NethraTypography.highContrastCaption,
    labelLarge: NethraTypography.highContrastBody,
  );
}