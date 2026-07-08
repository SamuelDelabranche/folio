import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'anilist_models.dart';

class AnilistRateLimitException implements Exception {
  final Duration retryAfter;
  const AnilistRateLimitException(this.retryAfter);

  @override
  String toString() => 'AniList : limite de requêtes atteinte '
      '(réessayer dans ${retryAfter.inSeconds} s)';
}

class AnilistNetworkException implements Exception {
  final String message;
  const AnilistNetworkException(this.message);

  @override
  String toString() => message;
}

class AnilistClient {
  static const _endpoint = 'https://graphql.anilist.co';
  static const _timeout = Duration(seconds: 10);

  final http.Client _http;

  AnilistClient([http.Client? client]) : _http = client ?? http.Client();

  static const _querySearch = r'''
query ($search: String) {
  Page(perPage: 10) {
    media(search: $search, type: MANGA) {
      id
      title { romaji english native }
      coverImage { medium }
      format
      countryOfOrigin
      startDate { year }
    }
  }
}''';

  static const _queryFetchById = r'''
query ($id: Int) {
  Media(id: $id, type: MANGA) {
    id
    title { romaji english native }
    description(asHtml: false)
    coverImage { extraLarge large }
    genres
    format
    countryOfOrigin
  }
}''';

  Future<List<AnilistSearchResult>> search(String titre) async {
    final data = await _post(_querySearch, {'search': titre});
    final page = data['Page'];
    final medias = page is Map<String, dynamic> ? page['media'] : null;
    if (medias is! List) return const [];
    return medias
        .map(AnilistSearchResult.depuisJson)
        .whereType<AnilistSearchResult>()
        .toList();
  }

  Future<AnilistMedia> fetchById(int id) async {
    final data = await _post(_queryFetchById, {'id': id});
    final media = AnilistMedia.depuisJson(data['Media']);
    if (media == null) {
      throw const AnilistNetworkException('Fiche AniList introuvable');
    }
    return media;
  }

  Future<Map<String, dynamic>> _post(
    String query,
    Map<String, dynamic> variables,
  ) async {
    late http.Response reponse;
    try {
      reponse = await _http
          .post(
            Uri.parse(_endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'query': query, 'variables': variables}),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const AnilistNetworkException('AniList ne répond pas (timeout)');
    } on http.ClientException {
      throw const AnilistNetworkException('Connexion à AniList impossible');
    }

    if (reponse.statusCode == 429) {
      final retryAfter =
          (int.tryParse(reponse.headers['retry-after'] ?? '') ?? 60)
              .clamp(5, 300);
      throw AnilistRateLimitException(Duration(seconds: retryAfter));
    }
    if (reponse.statusCode != 200) {
      throw AnilistNetworkException('AniList a répondu ${reponse.statusCode}');
    }

    final corps = jsonDecode(reponse.body);
    final data = corps is Map<String, dynamic> ? corps['data'] : null;
    if (data is! Map<String, dynamic>) {
      throw const AnilistNetworkException('Réponse AniList invalide');
    }
    return data;
  }

  void dispose() => _http.close();
}
