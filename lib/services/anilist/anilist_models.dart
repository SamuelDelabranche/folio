library;

class AnilistSearchResult {
  final int id;
  final String titre;
  final String? titreAnglais;
  final String? vignetteUrl;
  final String? format;
  final String? pays;
  final int? annee;

  const AnilistSearchResult({
    required this.id,
    required this.titre,
    this.titreAnglais,
    this.vignetteUrl,
    this.format,
    this.pays,
    this.annee,
  });

  static AnilistSearchResult? depuisJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    final id = (json['id'] as num?)?.toInt();
    final titre = _titreDepuisJson(json['title']);
    if (id == null || titre == null) return null;

    final title = json['title'];
    final cover = json['coverImage'];
    final startDate = json['startDate'];
    return AnilistSearchResult(
      id: id,
      titre: titre,
      titreAnglais: title is Map<String, dynamic> ? title['english'] as String? : null,
      vignetteUrl: cover is Map<String, dynamic> ? cover['medium'] as String? : null,
      format: json['format'] as String?,
      pays: json['countryOfOrigin'] as String?,
      annee: startDate is Map<String, dynamic> ? (startDate['year'] as num?)?.toInt() : null,
    );
  }

  String get sousTitre {
    final type = typeDepuisAnilist(format, pays);
    return annee != null ? '$type · $annee' : type;
  }
}

class AnilistMedia {
  final int id;
  final String? titre;
  final String? description;
  final String? coverUrl;
  final List<String> genres;
  final String? format;
  final String? pays;

  const AnilistMedia({
    required this.id,
    this.titre,
    this.description,
    this.coverUrl,
    this.genres = const [],
    this.format,
    this.pays,
  });

  static AnilistMedia? depuisJson(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    final id = (json['id'] as num?)?.toInt();
    if (id == null) return null;

    final cover = json['coverImage'];
    final genresBruts = json['genres'];
    return AnilistMedia(
      id: id,
      titre: _titreDepuisJson(json['title']),
      description: json['description'] is String
          ? nettoyerDescription(json['description'] as String)
          : null,
      coverUrl: cover is Map<String, dynamic>
          ? (cover['extraLarge'] as String? ?? cover['large'] as String?)
          : null,
      genres: genresBruts is List
          ? genresBruts.whereType<String>().toList()
          : const [],
      format: json['format'] as String?,
      pays: json['countryOfOrigin'] as String?,
    );
  }

  String get typeFolio => typeDepuisAnilist(format, pays);

  List<String> get genresFolio =>
      genres.map((g) => genresAnilistVersFolio[g]).whereType<String>().toList();
}

String? _titreDepuisJson(dynamic title) {
  if (title is! Map<String, dynamic>) return null;
  final romaji = title['romaji'];
  final english = title['english'];
  final native = title['native'];
  if (romaji is String && romaji.isNotEmpty) return romaji;
  if (english is String && english.isNotEmpty) return english;
  if (native is String && native.isNotEmpty) return native;
  return null;
}

String normaliserTitre(String s) =>
    s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9à-ÿ]+'), ' ').trim();

AnilistSearchResult? meilleurResultat(
  String titre,
  List<AnilistSearchResult> resultats,
) {
  if (resultats.isEmpty) return null;
  final cible = normaliserTitre(titre);
  if (cible.isEmpty) return resultats.first;
  for (final r in resultats) {
    if (normaliserTitre(r.titre) == cible) return r;
    if (r.titreAnglais != null && normaliserTitre(r.titreAnglais!) == cible) {
      return r;
    }
  }
  return resultats.first;
}

String typeDepuisAnilist(String? format, String? pays) {
  if (format == 'NOVEL') return 'Novel';
  return switch (pays) {
    'KR' => 'Manhwa',
    'CN' || 'TW' => 'Manhua',
    _ => 'Manga',
  };
}

const Map<String, String> genresAnilistVersFolio = {
  'Action': 'Action',
  'Adventure': 'Aventure',
  'Comedy': 'Comédie',
  'Drama': 'Drame',
  'Ecchi': 'Ecchi',
  'Fantasy': 'Fantaisie',
  'Horror': 'Horreur',
  'Mahou Shoujo': 'Magie',
  'Mecha': 'Mecha',
  'Music': 'Musique',
  'Mystery': 'Mystère',
  'Psychological': 'Psychologique',
  'Romance': 'Romance',
  'Sci-Fi': 'Science-fiction',
  'Slice of Life': 'Tranche de vie',
  'Sports': 'Sports',
  'Supernatural': 'Surnaturel',
  'Thriller': 'Thriller',
};

String nettoyerDescription(String brute) {
  var texte = brute.replaceAll(RegExp(r'~!.*?!~', dotAll: true), '');
  texte = texte.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
  texte = texte.replaceAll(RegExp(r'<[^>]+>'), '');
  texte = texte
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#039;', "'")
      .replaceAll('&rsquo;', "'");
  texte = texte.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  return texte.trim();
}
