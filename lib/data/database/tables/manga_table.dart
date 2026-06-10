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
}