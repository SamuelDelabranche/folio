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