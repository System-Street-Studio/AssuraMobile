import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryOrange,
      ),
      fontFamily: AppConstants.fontJost,
      scaffoldBackgroundColor: AppColors.backgroundWhite,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.primaryBlue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: AppConstants.fontJost,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFD9D9D9).withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textGrey,
          fontFamily: AppConstants.fontJost,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: AppConstants.fontJost,
          ),
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.primaryBlue,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: AppConstants.fontJost,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textBlack,
          fontSize: 15,
          fontFamily: AppConstants.fontJost,
        ),
      ),
    );
  }
}
