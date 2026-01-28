import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF863ED5);
  static const Color secondary = Color(0xFFF9B091);
  static const Color textPrimary = Color(0xFF240F4F);
  static const Color textSecondary = Color(0xFF8789A3);
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardGrey = Color(0xFFF3F3F5);
  
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFDF98FA), Color(0xFF9055FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
