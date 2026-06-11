import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/manga_table.dart';

part 'manga_dao.g.dart';

@DriftAccessor(tables: [MangaTable])
class MangaDao extends DatabaseAccessor<AppDatabase> with _$MangaDaoMixin {
  MangaDao(super.db);

  Future<List<MangaTableData>> getAllMangas() => select(mangaTable).get();

  /// Flux réactif : émet la liste complète à chaque écriture en base.
  /// C'est lui qui permet à l'UI de suivre les synchros d'arrière-plan.
  Stream<List<MangaTableData>> watchAllMangas() => select(mangaTable).watch();

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

  Future<void> deleteMangas(List<int> ids) {
    return (delete(mangaTable)..where((m) => m.id.isIn(ids))).go();
  }

  Future<void> deleteAllMangas() {
    return delete(mangaTable).go();
  }

  /// Remplace toute la bibliothèque de façon atomique : si une insertion
  /// échoue, la transaction est annulée et les données existantes sont
  /// conservées (utilisé par l'import).
  Future<void> replaceAllMangas(List<MangaTableCompanion> mangas) {
    return db.transaction(() async {
      await delete(mangaTable).go();
      await db.batch((b) => b.insertAll(mangaTable, mangas));
    });
  }
}
