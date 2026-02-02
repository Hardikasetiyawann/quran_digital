import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF863ED5);
  static const Color primaryLight = Color(0xFFDF98FA);
  static const Color primaryDark = Color(0xFF672CBC);
  
  static const Color secondary = Color(0xFFF9B091);
  static const Color accent = Color(0xFFF9B091);
  
  // Neutral Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF3F3F5);
  static const Color cardGrey = Color(0xFFF3F3F5);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF240F4F);
  static const Color textSecondary = Color(0xFF8789A3);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Specialized Colors
  static const Color gold = Color(0xFFFFD700);
  static const Color marker = Color(0xFF863ED5);
  
  // Gradients
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFDF98FA), Color(0xFF9055FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF863ED5), Color(0xFFB14BF4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFDF98FA), Color(0xFF9055FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
