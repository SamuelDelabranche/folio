import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/manga_table.dart';

part 'manga_dao.g.dart';

@DriftAccessor(tables: [MangaTable])
class MangaDao extends DatabaseAccessor<AppDatabase> with _$MangaDaoMixin {
  MangaDao(super.db);

  Future<List<MangaTableData>> getAllMangas() => select(mangaTable).get();
  Future<int> insertManga(MangaTableCompanion manga) => into(mangaTable).insert(manga);
}
