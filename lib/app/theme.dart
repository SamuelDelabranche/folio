import 'package:flutter/material.dart';

class AppColors {
    static const Color primary = Color(0xFF7C3AED);
    static const Color primaryLight = Color(0xFFA78BFA);
    static const Color accent = Color(0xFFEC4899);

    static const Color backgroundDark = Color(0xFF17141F);
    static const Color surfaceDark = Color(0xFF221E2C);
    static const Color surfaceLight = Color(0xFFF5F4F8);
    static const Color textSecondary = Color(0xFF9E9E9E);

    static const Color stars = Color(0xFFFFB300);
    static const Color danger = Color(0xFFE5484D);
    static const Color info = Color(0xFF90CAF9);
    static const Color success = Color(0xFFA5D6A7);

    static const Color statutALire = Color(0xFF378ADD);
    static const Color statutEnCours = Color(0xFFEF9F27);
    static const Color statutTermine = Color(0xFF639922);
    static const Color statutAbandonne = Color(0xFF888780);

    static Color couleurStatut(String statut) => switch (statut) {
        'À lire' => statutALire,
        'En cours' => statutEnCours,
        'Terminé' => statutTermine,
        'Abandonné' => statutAbandonne,
        _ => statutAbandonne,
    };

    static const List<Color> pastels = [
        Color(0xFFFFB3BA),
        Color(0xFFFFDFBA),
        Color(0xFFFFFFBA),
        Color(0xFFBAFFBA),
        Color(0xFFBAE1FF),
        Color(0xFFD4BAFF),
    ];

    static Color couleurNote(double note) {
        final n = note.clamp(0, 10).toDouble();
        return n <= 5
            ? Color.lerp(danger, stars, n / 5)!
            : Color.lerp(stars, statutTermine, (n - 5) / 5)!;
    }
}

class AppTheme {
    static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.primaryLight,
          secondary: AppColors.accent,
          surface: AppColors.surfaceDark,
        ),
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
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
