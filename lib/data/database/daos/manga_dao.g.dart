// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_dao.dart';

// ignore_for_file: type=lint
mixin _$MangaDaoMixin on DatabaseAccessor<AppDatabase> {
  $MangaTableTable get mangaTable => attachedDatabase.mangaTable;
  MangaDaoManager get managers => MangaDaoManager(this);
}

class MangaDaoManager {
  final _$MangaDaoMixin _db;
  MangaDaoManager(this._db);
  $$MangaTableTableTableManager get mangaTable =>
      $$MangaTableTableTableManager(_db.attachedDatabase, _db.mangaTable);
}
