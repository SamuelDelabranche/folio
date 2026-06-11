import 'package:flutter_test/flutter_test.dart';
import 'package:folio/services/anilist/sync_service.dart';
import 'package:folio/services/mangadex/mangadex_client.dart';

void main() {
  final fixture = {
    'id': 'abc-123',
    'attributes': {
      'title': {'en': 'Berserk'},
      'altTitles': [
        {'fr': 'Berserk (FR)'},
        {'ja': 'ベルセルク'},
      ],
      'description': {
        'en': 'English synopsis.',
        'fr': 'Guts, le **Guerrier Noir**, poursuit [sa vengeance](https://evil.com).\n\n---\nLiens externes',
      },
    },
    'relationships': [
      {
        'type': 'cover_art',
        'attributes': {'fileName': 'cover.jpg'},
      },
    ],
  };

  group('mangadexDepuisJson', () {
    test('parse une fiche complète', () {
      final manga = mangadexDepuisJson(fixture)!;
      expect(manga.id, 'abc-123');
      expect(manga.titres, contains('Berserk'));
      expect(manga.titres, contains('ベルセルク'));
      expect(manga.descriptionEn, 'English synopsis.');
      expect(manga.coverUrl,
          'https://uploads.mangadex.org/covers/abc-123/cover.jpg.512.jpg');
    });

    test('nettoie le markdown de la description française', () {
      final manga = mangadexDepuisJson(fixture)!;
      expect(manga.descriptionFr,
          'Guts, le Guerrier Noir, poursuit sa vengeance.');
    });

    test('rejette un fileName de cover suspect', () {
      final pirate = {
        'id': 'abc',
        'attributes': {'title': {'en': 'X'}},
        'relationships': [
          {
            'type': 'cover_art',
            'attributes': {'fileName': '../../etc/passwd'},
          },
        ],
      };
      expect(mangadexDepuisJson(pirate)!.coverUrl, isNull);
    });

    test('réponse malformée ne crash pas', () {
      expect(mangadexDepuisJson(null), isNull);
      expect(mangadexDepuisJson({'id': 42}), isNull);
      expect(mangadexDepuisJson({'id': 'x', 'attributes': 'rien'}), isNull);
    });
  });

  group('meilleurMangadex', () {
    test('exige une correspondance exacte de titre', () {
      final manga = mangadexDepuisJson(fixture)!;
      expect(meilleurMangadex('Berserk', [manga])?.id, 'abc-123');
      expect(meilleurMangadex('berserk !', [manga])?.id, 'abc-123');
      expect(meilleurMangadex('Titre différent', [manga]), isNull);
    });
  });

  group('urlCoverAutorisee', () {
    test('accepte AniList et MangaDex en https uniquement', () {
      expect(urlCoverAutorisee('https://s4.anilist.co/cover.jpg'), isTrue);
      expect(urlCoverAutorisee('https://uploads.mangadex.org/covers/a/b.jpg'), isTrue);
      expect(urlCoverAutorisee('http://s4.anilist.co/cover.jpg'), isFalse);
      expect(urlCoverAutorisee('https://evil.com/cover.jpg'), isFalse);
      expect(urlCoverAutorisee('https://fakeanilist.co.evil.com/x.jpg'), isFalse);
      expect(urlCoverAutorisee('https://mangadex.org.evil.com/x.jpg'), isFalse);
    });
  });
}
