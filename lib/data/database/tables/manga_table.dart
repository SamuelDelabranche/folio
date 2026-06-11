import 'package:drift/drift.dart';

class MangaTable extends Table{
  IntColumn get id => integer().autoIncrement()();

  TextColumn get titre => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get status => text()();
  TextColumn get genre => text().nullable()();
  TextColumn get typeManga => text()();

  BoolColumn get estFavori => boolean()();

  RealColumn get note => real()();
  RealColumn get chapitres => real()();

  TextColumn get liens => text().nullable()();

  // ── Synchronisation AniList (schéma v4) ──
  // Voir docs/ANILIST_SYNC.md. Les toggles sync* sont combinés en "filtre ET"
  // avec les réglages globaux des Paramètres.
  IntColumn get anilistId => integer().nullable()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  BoolColumn get syncImage => boolean().withDefault(const Constant(true))();
  BoolColumn get syncDescription => boolean().withDefault(const Constant(true))();
  BoolColumn get syncGenres => boolean().withDefault(const Constant(true))();
  BoolColumn get syncType => boolean().withDefault(const Constant(true))();

  /// Provenance de l'image : 'aucune' | 'utilisateur' | 'anilist'.
  /// Une image 'utilisateur' n'est jamais écrasée par la synchro.
  TextColumn get imageSource => text().withDefault(const Constant('aucune'))();
}