import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/data/database/daos/manga_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final mangaDaoProvider = Provider<MangaDao>((ref) => MangaDao(ref.read(databaseProvider)));
final mangasProvider = FutureProvider<List<MangaTableData>>((ref) {
  final dao = ref.read(mangaDaoProvider);
  return dao.getAllMangas();
});