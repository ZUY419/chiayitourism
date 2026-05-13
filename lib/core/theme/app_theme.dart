import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors (嘉義意象 - 暖橙/土黃為主色調)
  static const Color primary = Color(0xFFE07B39);
  static const Color primaryDark = Color(0xFFC05F1E);
  static const Color secondary = Color(0xFF4A9B6F);
  static const Color background = Color(0xFFF8F5F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color error = Color(0xFFD32F2F);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      background: background,
      surface: surface,
      error: error,
    ),
    fontFamily: 'NotoSansTC',
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'NotoSansTC',
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      filled: true,
      fillColor: surface,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    //cardTheme: CardTheme(
      //color: surface,
      //elevation: 2,
      //shadowColor: Colors.black12,
      //shape: RoundedRectangleBorder(
        //borderRadius: BorderRadius.circular(16),
      //),
    //),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: background,
      selectedColor: primary.withOpacity(0.2),
      labelStyle: const TextStyle(fontSize: 13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}