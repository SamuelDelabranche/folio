import 'package:flutter_test/flutter_test.dart';
import 'package:folio/services/anilist/anilist_models.dart';

void main() {
  group('typeDepuisAnilist', () {
    test('déduit le type depuis le pays', () {
      expect(typeDepuisAnilist('MANGA', 'JP'), 'Manga');
      expect(typeDepuisAnilist('MANGA', 'KR'), 'Manhwa');
      expect(typeDepuisAnilist('MANGA', 'CN'), 'Manhua');
      expect(typeDepuisAnilist('MANGA', 'TW'), 'Manhua');
    });

    test('NOVEL prime sur le pays', () {
      expect(typeDepuisAnilist('NOVEL', 'KR'), 'Novel');
    });

    test('inconnu retombe sur Manga', () {
      expect(typeDepuisAnilist(null, null), 'Manga');
      expect(typeDepuisAnilist('ONE_SHOT', 'US'), 'Manga');
    });
  });

  group('nettoyerDescription', () {
    test('retire les spoilers et les balises', () {
      const brute =
          'Début.<br><br>Suite en <i>italique</i>.~!gros spoiler!~ Fin.';
      expect(nettoyerDescription(brute), 'Début.\n\nSuite en italique. Fin.');
    });

    test('décode les entités basiques', () {
      expect(nettoyerDescription('A &amp; B &quot;C&quot;'), 'A & B "C"');
    });
  });

  group('AnilistMedia.depuisJson', () {
    final fixture = {
      'id': 30002,
      'title': {'romaji': 'Berserk', 'english': null, 'native': 'ベルセルク'},
      'description': 'Guts<br>~!spoiler!~',
      'coverImage': {'extraLarge': 'https://s4.anilist.co/cover.jpg', 'large': null},
      'genres': ['Action', 'Horror', 'GenreInconnu'],
      'format': 'MANGA',
      'countryOfOrigin': 'JP',
    };

    test('parse une fiche complète', () {
      final media = AnilistMedia.depuisJson(fixture)!;
      expect(media.id, 30002);
      expect(media.titre, 'Berserk');
      expect(media.description, 'Guts');
      expect(media.coverUrl, 'https://s4.anilist.co/cover.jpg');
      expect(media.typeFolio, 'Manga');
      expect(media.genresFolio, ['Action', 'Horreur']);
    });

    test('les genres inconnus sont ignorés', () {
      final media = AnilistMedia.depuisJson(fixture)!;
      expect(media.genresFolio.contains('GenreInconnu'), isFalse);
    });

    test('réponse malformée ne crash pas', () {
      expect(AnilistMedia.depuisJson(null), isNull);
      expect(AnilistMedia.depuisJson('pas un objet'), isNull);
      expect(AnilistMedia.depuisJson(<String, dynamic>{}), isNull);
      final partiel = AnilistMedia.depuisJson({'id': 1, 'title': 'mauvais type'});
      expect(partiel, isNotNull);
      expect(partiel!.titre, isNull);
      expect(partiel.genres, isEmpty);
    });
  });

  group('AnilistSearchResult.depuisJson', () {
    test('exige id et titre', () {
      expect(AnilistSearchResult.depuisJson({'id': 1}), isNull);
      expect(
        AnilistSearchResult.depuisJson({
          'id': 1,
          'title': {'romaji': 'Solo Leveling'},
          'countryOfOrigin': 'KR',
          'startDate': {'year': 2018},
        })?.sousTitre,
        'Manhwa · 2018',
      );
    });
  });
}
