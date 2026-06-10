import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/manga_table.dart';
import 'daos/manga_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [MangaTable], daos: [MangaDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  MangaDao get mangaDao => MangaDao(this);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(mangaTable, mangaTable.genre);
      }
      if (from < 3) {
        await m.addColumn(mangaTable, mangaTable.liens);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'folio_db');
  }
}
