import 'package:flutter_test/flutter_test.dart';
import 'package:folio/app/constants.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/generated/app_localizations_en.dart';
import 'package:folio/generated/app_localizations_fr.dart';

void main() {
  final fr = AppLocalizationsFr();
  final en = AppLocalizationsEn();

  group('genreLabel', () {
    test('traduit les genres connus en français', () {
      expect(genreLabel('Adventure', fr), 'Aventure');
      expect(genreLabel('Slice of Life', fr), 'Tranche de vie');
      expect(genreLabel('Sci-Fi', fr), 'Science-fiction');
    });

    test('garde la valeur canonique en anglais', () {
      expect(genreLabel('Adventure', en), 'Adventure');
      expect(genreLabel('Martial Arts', en), 'Martial Arts');
    });

    test('retombe sur la valeur brute pour un genre personnalisé', () {
      expect(genreLabel('Webtoon coréen', fr), 'Webtoon coréen');
      expect(genreLabel('Webtoon coréen', en), 'Webtoon coréen');
    });
  });

  group('statusLabel', () {
    test('traduit les statuts stockés en base', () {
      expect(statusLabel('À lire', en), 'To read');
      expect(statusLabel('En cours', en), 'Reading');
      expect(statusLabel('Terminé', fr), 'Terminé');
    });

    test('retombe sur la valeur brute pour un statut inconnu', () {
      expect(statusLabel('Inconnu', fr), 'Inconnu');
    });
  });

  group('nettoyerTag', () {
    test('supprime les virgules', () {
      expect(nettoyerTag('Action, RPG'), 'Action RPG');
      expect(nettoyerTag(',,,'), '');
    });

    test('normalise les espaces', () {
      expect(nettoyerTag('  Web   toon  '), 'Web toon');
    });

    test('conserve un tag propre', () {
      expect(nettoyerTag('Webtoon'), 'Webtoon');
    });
  });
}
