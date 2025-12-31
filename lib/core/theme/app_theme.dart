import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accent),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(elevation: 1),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    colorScheme: ColorScheme.dark(primary: AppColors.primaryDark, secondary: AppColors.accent),
    scaffoldBackgroundColor: const Color(0xFF07112B), // deep blue background
    appBarTheme: const AppBarTheme(elevation: 1, backgroundColor: Color(0xFF07112B)),
    cardColor: const Color(0xFF0A274D),
    iconTheme: const IconThemeData(color: Colors.white70),
    textTheme: ThemeData.dark().textTheme,
  );
} 