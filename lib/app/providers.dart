import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/data/database/daos/manga_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final mangaDaoProvider = Provider<MangaDao>((ref) => MangaDao(ref.read(databaseProvider)));
final mangasProvider = FutureProvider<List<MangaTableData>>((ref) {
  final dao = ref.read(mangaDaoProvider);
  return dao.getAllMangas();
});

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

/// Onglet affiché au lancement (0 = Bibliothèque, 1 = Statistiques, 2 = Paramètres).
final startTabProvider = NotifierProvider<StartTabNotifier, int>(StartTabNotifier.new);

class StartTabNotifier extends Notifier<int> {
  static const _key = 'start_tab';

  @override
  int build() => 0;

  Future<void> set(int index) async {
    state = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, index);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = (prefs.getInt(_key) ?? 0).clamp(0, 2);
  }
}

/// Modes d'affichage de la bibliothèque.
enum ViewMode { grille, liste, compact }

final viewModeProvider = NotifierProvider<ViewModeNotifier, ViewMode>(ViewModeNotifier.new);

class ViewModeNotifier extends Notifier<ViewMode> {
  static const _key = 'view_mode';

  @override
  ViewMode build() => ViewMode.grille;

  Future<void> set(ViewMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  /// Passe au mode suivant (bouton de bascule dans la bibliothèque).
  Future<void> suivant() =>
      set(ViewMode.values[(state.index + 1) % ViewMode.values.length]);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      state = ViewMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => ViewMode.grille,
      );
    }
  }
}

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() => ThemeMode.system;

  Future<void> set(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      state = ThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => ThemeMode.system,
      );
    }
  }
}