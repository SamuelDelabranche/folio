import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/manga_dao.dart';
import 'tables/manga_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [MangaTable], daos: [MangaDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  MangaDao get mangaDao => MangaDao(this);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(mangaTable, mangaTable.genre);
      }
      if (from < 3) {
        await m.addColumn(mangaTable, mangaTable.liens);
      }
      if (from < 4) {
        await m.addColumn(mangaTable, mangaTable.anilistId);
        await m.addColumn(mangaTable, mangaTable.lastSyncedAt);
        await m.addColumn(mangaTable, mangaTable.syncImage);
        await m.addColumn(mangaTable, mangaTable.syncDescription);
        await m.addColumn(mangaTable, mangaTable.syncGenres);
        await m.addColumn(mangaTable, mangaTable.syncType);
        await m.addColumn(mangaTable, mangaTable.imageSource);
        await customStatement(
          "UPDATE manga_table SET image_source = 'utilisateur' "
          'WHERE image_path IS NOT NULL',
        );
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'folio_db');
  }
}
