import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/manga_table.dart';

part 'manga_dao.g.dart';

@DriftAccessor(tables: [MangaTable])
class MangaDao extends DatabaseAccessor<AppDatabase> with _$MangaDaoMixin {
  MangaDao(super.db);

  Future<List<MangaTableData>> getAllMangas() => select(mangaTable).get();

  Future<int> insertManga(MangaTableCompanion manga) =>
      into(mangaTable).insert(manga);

  Future<bool> updateManga(MangaTableData manga) =>
      update(mangaTable).replace(manga);

  Future<void> updateMangaByElement(int id, MangaTableCompanion companion) {
    return (update(mangaTable)..where((m) => m.id.equals(id))).write(companion);
  }

  Future<void> deleteManga(int id) {
    return (delete(mangaTable)..where((m) => m.id.equals(id))).go();
  }
}
