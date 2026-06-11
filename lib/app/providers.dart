import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/data/database/daos/manga_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final mangaDaoProvider = Provider<MangaDao>((ref) => MangaDao(ref.read(databaseProvider)));
final mangasProvider = StreamProvider<List<MangaTableData>>((ref) {
  final dao = ref.read(mangaDaoProvider);
  return dao.watchAllMangas();
});

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

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

class SyncPrefs {
  final bool maitre;
  final bool image;
  final bool description;
  final bool genres;
  final bool type;
  final bool mangadex;

  const SyncPrefs({
    this.maitre = true,
    this.image = true,
    this.description = true,
    this.genres = true,
    this.type = true,
    this.mangadex = true,
  });

  SyncPrefs copyWith({bool? maitre, bool? image, bool? description, bool? genres, bool? type, bool? mangadex}) {
    return SyncPrefs(
      maitre: maitre ?? this.maitre,
      image: image ?? this.image,
      description: description ?? this.description,
      genres: genres ?? this.genres,
      type: type ?? this.type,
      mangadex: mangadex ?? this.mangadex,
    );
  }
}

final syncPrefsProvider = NotifierProvider<SyncPrefsNotifier, SyncPrefs>(SyncPrefsNotifier.new);

class SyncPrefsNotifier extends Notifier<SyncPrefs> {
  static const _keys = {
    'maitre': 'sync_enabled',
    'image': 'sync_image_global',
    'description': 'sync_description_global',
    'genres': 'sync_genres_global',
    'type': 'sync_type_global',
    'mangadex': 'sync_mangadex_global',
  };

  @override
  SyncPrefs build() => const SyncPrefs();

  Future<void> _save(String champ, bool valeur) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keys[champ]!, valeur);
  }

  Future<void> setMaitre(bool v) async { state = state.copyWith(maitre: v); await _save('maitre', v); }
  Future<void> setImage(bool v) async { state = state.copyWith(image: v); await _save('image', v); }
  Future<void> setDescription(bool v) async { state = state.copyWith(description: v); await _save('description', v); }
  Future<void> setGenres(bool v) async { state = state.copyWith(genres: v); await _save('genres', v); }
  Future<void> setType(bool v) async { state = state.copyWith(type: v); await _save('type', v); }
  Future<void> setMangadex(bool v) async { state = state.copyWith(mangadex: v); await _save('mangadex', v); }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = SyncPrefs(
      maitre: prefs.getBool(_keys['maitre']!) ?? true,
      image: prefs.getBool(_keys['image']!) ?? true,
      description: prefs.getBool(_keys['description']!) ?? true,
      genres: prefs.getBool(_keys['genres']!) ?? true,
      type: prefs.getBool(_keys['type']!) ?? true,
      mangadex: prefs.getBool(_keys['mangadex']!) ?? true,
    );
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
