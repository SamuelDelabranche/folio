import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:folio/services/anilist/anilist_models.dart';

class MangadexManga {
  final String id;
  final List<String> titres;
  final String? descriptionFr;
  final String? descriptionEn;
  final String? coverUrl;

  const MangadexManga({
    required this.id,
    this.titres = const [],
    this.descriptionFr,
    this.descriptionEn,
    this.coverUrl,
  });
}

class MangadexClient {
  static const _endpoint = 'https://api.mangadex.org';
  static const _timeout = Duration(seconds: 10);

  final http.Client _http;

  MangadexClient([http.Client? client]) : _http = client ?? http.Client();

  Future<MangadexManga?> chercher(String titre) async {
    if (titre.trim().isEmpty) return null;
    final uri = Uri.parse('$_endpoint/manga').replace(queryParameters: {
      'title': titre,
      'limit': '5',
      'includes[]': 'cover_art',
    });
    final reponse = await _http.get(uri, headers: {
      'Accept': 'application/json',
      'User-Agent': 'Folio/2.0 (https://github.com/SamuelDelabranche/folio)',
    }).timeout(_timeout);
    if (reponse.statusCode != 200) return null;

    final corps = jsonDecode(reponse.body);
    final data = corps is Map<String, dynamic> ? corps['data'] : null;
    if (data is! List) return null;

    final candidats =
        data.map(mangadexDepuisJson).whereType<MangadexManga>().toList();
    return meilleurMangadex(titre, candidats);
  }

  void dispose() => _http.close();
}

MangadexManga? mangadexDepuisJson(dynamic json) {
  if (json is! Map<String, dynamic>) return null;
  final id = json['id'];
  final attributs = json['attributes'];
  if (id is! String || id.isEmpty || attributs is! Map<String, dynamic>) {
    return null;
  }

  final titres = <String>[];
  final title = attributs['title'];
  if (title is Map<String, dynamic>) {
    titres.addAll(title.values.whereType<String>());
  }
  final altTitles = attributs['altTitles'];
  if (altTitles is List) {
    for (final alt in altTitles) {
      if (alt is Map<String, dynamic>) {
        titres.addAll(alt.values.whereType<String>());
      }
    }
  }

  String? fr;
  String? en;
  final description = attributs['description'];
  if (description is Map<String, dynamic>) {
    final brutFr = description['fr'];
    final brutEn = description['en'];
    if (brutFr is String && brutFr.trim().isNotEmpty) {
      fr = nettoyerDescriptionMangadex(brutFr);
    }
    if (brutEn is String && brutEn.trim().isNotEmpty) {
      en = nettoyerDescriptionMangadex(brutEn);
    }
  }

  String? coverUrl;
  final relations = json['relationships'];
  if (relations is List) {
    for (final rel in relations) {
      if (rel is Map<String, dynamic> && rel['type'] == 'cover_art') {
        final attrs = rel['attributes'];
        final fichier = attrs is Map<String, dynamic> ? attrs['fileName'] : null;
        if (fichier is String &&
            fichier.isNotEmpty &&
            !fichier.contains('/') &&
            !fichier.contains('\\') &&
            !fichier.contains('..')) {
          coverUrl = 'https://uploads.mangadex.org/covers/$id/$fichier.512.jpg';
        }
        break;
      }
    }
  }

  return MangadexManga(
    id: id,
    titres: titres,
    descriptionFr: fr,
    descriptionEn: en,
    coverUrl: coverUrl,
  );
}

MangadexManga? meilleurMangadex(String titre, List<MangadexManga> candidats) {
  final cible = normaliserTitre(titre);
  if (cible.isEmpty) return null;
  for (final c in candidats) {
    if (c.titres.any((t) => normaliserTitre(t) == cible)) return c;
  }
  return null;
}

String nettoyerDescriptionMangadex(String brute) {
  var texte = brute.split(RegExp(r'\n-{3,}')).first;
  texte = texte.replaceAllMapped(
    RegExp(r'\[([^\]]*)\]\([^)]*\)'),
    (m) => m[1] ?? '',
  );
  texte = texte.replaceAll(RegExp(r'[*_]{1,3}'), '');
  texte = texte.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  return texte.trim();
}
