import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:folio/app/providers.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/services/cover_service.dart';
import 'package:folio/services/anilist/anilist_client.dart';
import 'package:folio/services/anilist/anilist_models.dart';

bool urlCoverAutorisee(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) return false;
  return uri.host == 'anilist.co' || uri.host.endsWith('.anilist.co');
}

final syncServiceProvider = Provider<SyncService>((ref) => SyncService(ref));

class SyncService {
  final Ref _ref;
  final AnilistClient client;

  SyncService(this._ref, [AnilistClient? clientInjecte])
      : client = clientInjecte ?? AnilistClient();

  Future<bool> lierAuto(MangaTableData manga) async {
    if (manga.anilistId != null) return true;
    if (manga.titre.trim().isEmpty) return false;
    final resultats = await client.search(manga.titre);
    final choix = meilleurResultat(manga.titre, resultats);
    if (choix == null) return false;
    await _ref.read(mangaDaoProvider).updateMangaByElement(
          manga.id,
          MangaTableCompanion(anilistId: Value(choix.id)),
        );
    return true;
  }

  Future<bool> syncOne(MangaTableData manga) async {
    final prefs = _ref.read(syncPrefsProvider);
    if (!prefs.maitre || manga.anilistId == null) return false;

    final media = await client.fetchById(manga.anilistId!);
    var companion = MangaTableCompanion(lastSyncedAt: Value(DateTime.now()));

    if (prefs.description && manga.syncDescription) {
      final description = media.description;
      if (description != null && description.isNotEmpty) {
        companion = companion.copyWith(description: Value(description));
      }
    }
    if (prefs.genres && manga.syncGenres && media.genresFolio.isNotEmpty) {
      companion = companion.copyWith(genre: Value(media.genresFolio.join(',')));
    }
    if (prefs.type && manga.syncType) {
      companion = companion.copyWith(typeManga: Value(media.typeFolio));
    }
    if (prefs.image && manga.syncImage && manga.imageSource != 'utilisateur') {
      final coverUrl = media.coverUrl;
      if (coverUrl != null && urlCoverAutorisee(coverUrl)) {
        final chemin = await _telechargerCover(coverUrl, manga.anilistId!);
        if (chemin != null) {
          if (manga.imagePath != null && manga.imagePath != chemin) {
            await CoverService.supprimerCover(manga.imagePath);
          }
          companion = companion.copyWith(
            imagePath: Value(chemin),
            imageSource: const Value('anilist'),
          );
          await FileImage(File(chemin)).evict();
        }
      }
    }

    await _ref.read(mangaDaoProvider).updateMangaByElement(manga.id, companion);
    return true;
  }

  Future<String?> _telechargerCover(String url, int anilistId) async {
    http.Client? clientHttp;
    try {
      final requete = http.Request('GET', Uri.parse(url))
        ..followRedirects = false;
      clientHttp = http.Client();
      final flux = await clientHttp
          .send(requete)
          .timeout(const Duration(seconds: 10));
      if (flux.statusCode != 200) return null;
      if ((flux.contentLength ?? 0) > CoverService.tailleMaxOctets) return null;
      final octets =
          await flux.stream.toBytes().timeout(const Duration(seconds: 20));
      if (octets.length > CoverService.tailleMaxOctets) return null;
      return await CoverService.installerCover(octets, 'anilist_$anilistId.jpg');
    } catch (_) {
      return null;
    } finally {
      clientHttp?.close();
    }
  }
}
