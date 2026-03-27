import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/manga_table.dart';
import 'daos/manga_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [MangaTable], daos: [MangaDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  late final MangaDao mangaDao = MangaDao(this);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'folio_db');
  }
}
