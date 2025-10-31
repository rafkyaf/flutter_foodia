import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
class AppTheme { static final ThemeData lightTheme = ThemeData(primaryColor: AppColors.primary, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accent), scaffoldBackgroundColor: Colors.white, appBarTheme: const AppBarTheme(elevation: 1), ); }