
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: AppColors.fondo,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.morado,
        primary: AppColors.azulPrincipal,
        secondary: AppColors.morado,
        surface: AppColors.blanco,
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.azulPrincipal,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.azulPrincipal,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.texto,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.texto,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.fondo,
        foregroundColor: AppColors.azulPrincipal,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.azulPrincipal,
          fontWeight: FontWeight.w600,
          fontSize: 19,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.morado,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
