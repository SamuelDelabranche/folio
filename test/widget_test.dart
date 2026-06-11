import 'package:flutter_test/flutter_test.dart';
import 'package:folio/data/models/lien.dart';

void main() {
  group('Lien JSON', () {
    test('aller-retour sérialisation', () {
      const liens = [
        Lien(nom: 'Scan VF', url: 'https://exemple.com/manga'),
        Lien(nom: 'Officiel', url: 'http://editeur.fr'),
      ];
      final json = liensToJson(liens);
      final relus = liensFromJson(json);
      expect(relus.length, 2);
      expect(relus.first.nom, 'Scan VF');
      expect(relus.first.url, 'https://exemple.com/manga');
    });

    test('json null ou vide donne une liste vide', () {
      expect(liensFromJson(null), isEmpty);
      expect(liensFromJson(''), isEmpty);
    });
  });

  group('urlEstValide', () {
    test('accepte http et https', () {
      expect(urlEstValide('https://anilist.co/manga/30013'), isTrue);
      expect(urlEstValide('http://exemple.com'), isTrue);
      expect(urlEstValide('  https://exemple.com  '), isTrue);
    });

    test('rejette les schemes dangereux ou invalides', () {
      expect(urlEstValide('javascript:alert(1)'), isFalse);
      expect(urlEstValide('file:///etc/passwd'), isFalse);
      expect(urlEstValide('intent://scan'), isFalse);
      expect(urlEstValide('pas une url'), isFalse);
      expect(urlEstValide(''), isFalse);
    });
  });
}
