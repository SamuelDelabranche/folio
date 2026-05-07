import 'package:flutter/material.dart';

class AppColors {
    static const Color accentDark = Color(0xFFBB86FC);
    static const Color accentLight = Color(0xFF6200EE);
    static const Color backgroundDark = Color(0xFF121212);
    static const Color surfaceDark = Color(0xFF1E1E1E);
    static const Color surfaceLight = Color(0xFFF5F5F5);
    static const Color textSecondary = Color(0xFF9E9E9E);
    static const Color stars = Color(0xFFFFD700);

    static const Color danger = Color(0xFFCF6679);
    static const Color info = Color(0xFF90CAF9);
    static const Color success = Color(0xFFA5D6A7);
}

class AppTheme {
    static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accentDark, brightness: Brightness.dark),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
    );
    static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.surfaceLight,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accentLight, brightness: Brightness.light),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
    );
}