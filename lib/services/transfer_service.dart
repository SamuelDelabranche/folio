import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/data/models/lien.dart';

class ImportResult {
  final List<MangaTableCompanion> mangas;
  final List<String> customGenres;
  final List<String> customTypes;

  const ImportResult({
    required this.mangas,
    required this.customGenres,
    required this.customTypes,
  });
}

Map<String, dynamic> mangaVersJson(MangaTableData manga) => {
      'titre': manga.titre,
      'description': manga.description,
      'imagePath': manga.imagePath,
      'status': manga.status,
      'genre': manga.genre,
      'typeManga': manga.typeManga,
      'estFavori': manga.estFavori,
      'note': manga.note,
      'chapitres': manga.chapitres,
      'liens': manga.liens,
      'anilistId': manga.anilistId,
      'lastSyncedAt': manga.lastSyncedAt?.toIso8601String(),
      'syncImage': manga.syncImage,
      'syncDescription': manga.syncDescription,
      'syncGenres': manga.syncGenres,
      'syncType': manga.syncType,
      'imageSource': manga.imageSource,
    };

String exporterEnJson(
  List<MangaTableData> mangas,
  List<String> customGenres,
  List<String> customTypes,
) =>
    jsonEncode({
      'mangas': mangas.map(mangaVersJson).toList(),
      if (customGenres.isNotEmpty) 'custom_genres': customGenres,
      if (customTypes.isNotEmpty) 'custom_types': customTypes,
    });

ImportResult importerDepuisJson(String contenu) {
  final dynamic decoded = jsonDecode(contenu);

  final List<dynamic> listeJson;
  final List<String> genres;
  final List<String> types;

  if (decoded is List) {
    listeJson = decoded;
    genres = [];
    types = [];
  } else if (decoded is Map<String, dynamic>) {
    listeJson = decoded['mangas'] as List<dynamic>? ?? [];
    genres = [
      for (final g in decoded['custom_genres'] as List? ?? [])
        if (g is String) g,
    ];
    types = [
      for (final t in decoded['custom_types'] as List? ?? [])
        if (t is String) t,
    ];
  } else {
    throw const FormatException('Format invalide');
  }

  return ImportResult(
    mangas: listeJson.map(companionDepuisJson).toList(),
    customGenres: genres,
    customTypes: types,
  );
}

MangaTableCompanion companionDepuisJson(dynamic item) {
  if (item is! Map<String, dynamic>) {
    throw const FormatException('Item invalide');
  }
  final titre = item['titre'];
  if (titre is! String || titre.trim().isEmpty) {
    throw const FormatException('Titre manquant');
  }
  final note = ((item['note'] as num?)?.toDouble() ?? 0).clamp(0.0, 10.0);
  final chapitres = ((item['chapitres'] as num?)?.toDouble() ?? 0).clamp(0.0, double.maxFinite);

  String? liensJson = item['liens'] as String?;
  if (liensJson != null && liensJson.isNotEmpty) {
    final liens = liensFromJson(liensJson).where((l) => urlEstValide(l.url)).toList();
    liensJson = liensToJson(liens);
  }

  final anilistId = (item['anilistId'] as num?)?.toInt();
  final lastSyncedAt = item['lastSyncedAt'] is String
      ? DateTime.tryParse(item['lastSyncedAt'] as String)
      : null;

  String? imagePath = item['imagePath'] as String?;
  if (imagePath != null && !File(imagePath).existsSync()) {
    imagePath = null;
  }
  var imageSource = item['imageSource'] as String?;
  if (!const ['aucune', 'utilisateur', 'anilist'].contains(imageSource)) {
    imageSource = imagePath != null ? 'utilisateur' : 'aucune';
  }
  if (imagePath == null) imageSource = 'aucune';

  return MangaTableCompanion(
    titre: Value(titre.trim()),
    description: Value(item['description'] as String?),
    imagePath: Value(imagePath),
    status: Value(item['status'] as String? ?? 'À lire'),
    genre: Value(item['genre'] as String?),
    typeManga: Value(item['typeManga'] as String? ?? 'Manga'),
    estFavori: Value(item['estFavori'] as bool? ?? false),
    note: Value(note),
    chapitres: Value(chapitres),
    liens: Value(liensJson),
    anilistId: Value(anilistId),
    lastSyncedAt: Value(lastSyncedAt),
    syncImage: Value(item['syncImage'] as bool? ?? true),
    syncDescription: Value(item['syncDescription'] as bool? ?? true),
    syncGenres: Value(item['syncGenres'] as bool? ?? true),
    syncType: Value(item['syncType'] as bool? ?? true),
    imageSource: Value(imageSource!),
  );
}
