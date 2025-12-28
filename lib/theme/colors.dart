import 'package:flutter/material.dart';

/// Cyberpunk Bengaluru Color Palette for Nethra App
class NethraPalette {
  // Primary Colors
  static const Color deepIndigo = Color(0xFF1A1A2E);      // Background
  static const Color neonCyan = Color(0xFF00FFF5);        // Primary Accent
  static const Color electricPurple = Color(0xFF7B2CBF);  // Secondary Accent
  
  // Supporting Colors
  static const Color darkSlate = Color(0xFF16213E);       // Card Background
  static const Color softWhite = Color(0xFFE8E8E8);       // Text Primary
  static const Color mutedGray = Color(0xFF9E9E9E);       // Text Secondary
  
  // Accessibility (Blind Mode)
  static const Color highContrastBg = Color(0xFF000000);  // Black Background
  static const Color highContrastText = Color(0xFFFFFF00); // Yellow Text
  
  // Glass Effect Colors
  static const Color glassColor = Color(0x1AFFFFFF);      // Glass overlay
  static const Color glassBorder = Color(0x33FFFFFF);     // Glass border
  
  // Status Colors
  static const Color success = Color(0xFF00FF88);         // Success green
  static const Color warning = Color(0xFFFFAA00);         // Warning orange
  static const Color error = Color(0xFFFF3366);           // Error red
  
  // Gradient Colors
  static const LinearGradient neonGradient = LinearGradient(
    colors: [neonCyan, electricPurple],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [deepIndigo, darkSlate],
    stops: [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Glass morphism configuration
class GlassConfig {
  static const double blurRadius = 10.0;
  static const double opacity = 0.1;
  static const double borderRadius = 16.0;
  static const Color glassColor = Color(0x1AFFFFFF);
  static const double borderOpacity = 0.2;
}