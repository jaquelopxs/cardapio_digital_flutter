import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF5A0B1E); // Vinho escuro
  static const Color primaryLight = Color(0xFF8B1538); // Vinho claro
  static const Color accent = Color(0xFFF0E6D2); // Dourado/Creme
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF9FAFB);
  static const Color dark = Color(0xFF111827); // Footer/Dark background

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
}
