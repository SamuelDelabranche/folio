import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/data/models/lien.dart';
import 'package:folio/services/transfer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

MangaTableData fabriqueManga({
  int id = 1,
  String titre = 'Titre',
  String? description,
  String? imagePath,
  String status = 'En cours',
  String? genre,
  String typeManga = 'Manga',
  bool estFavori = false,
  double note = 5,
  double chapitres = 10,
  String? liens,
  int? anilistId,
  DateTime? lastSyncedAt,
  String imageSource = 'aucune',
}) =>
    MangaTableData(
      id: id,
      titre: titre,
      description: description,
      imagePath: imagePath,
      status: status,
      genre: genre,
      typeManga: typeManga,
      estFavori: estFavori,
      note: note,
      chapitres: chapitres,
      liens: liens,
      anilistId: anilistId,
      lastSyncedAt: lastSyncedAt,
      syncImage: true,
      syncDescription: true,
      syncGenres: true,
      syncType: true,
      imageSource: imageSource,
    );

void main() {
  group('Persona 1 — Léa, bibliothèque vide', () {
    test('import d\'un export vide ne plante pas', () {
      final import = importerDepuisJson('{"mangas": []}');
      expect(import.mangas, isEmpty);
      expect(import.customGenres, isEmpty);
      expect(import.customTypes, isEmpty);
    });
  });

  group('Persona 2 — Tom, casual (3 mangas minimaux)', () {
    test('aller-retour sans perte', () {
      final mangas = [
        fabriqueManga(titre: 'One Piece', chapitres: 1100),
        fabriqueManga(id: 2, titre: 'Naruto', status: 'Terminé', chapitres: 700),
        fabriqueManga(id: 3, titre: 'Berserk', status: 'À lire', chapitres: 0),
      ];
      final import = importerDepuisJson(exporterEnJson(mangas, [], []));
      expect(import.mangas.length, 3);
      expect(import.mangas[0].titre.value, 'One Piece');
      expect(import.mangas[1].status.value, 'Terminé');
      expect(import.mangas[2].chapitres.value, 0);
      expect(import.mangas[0].description.value, isNull);
      expect(import.mangas[0].genre.value, isNull);
    });
  });

  group('Persona 3 — Sarah, standard (25 mangas variés)', () {
    test('favoris, notes et genres préservés', () {
      final mangas = List.generate(25, (i) => fabriqueManga(
            id: i + 1,
            titre: 'Manga $i',
            genre: i % 2 == 0 ? 'Action,Romance' : 'Fantasy',
            estFavori: i % 5 == 0,
            note: (i % 11).toDouble(),
            typeManga: ['Manga', 'Manhwa', 'Manhua', 'Novel'][i % 4],
          ));
      final import = importerDepuisJson(exporterEnJson(mangas, [], []));
      expect(import.mangas.length, 25);
      expect(import.mangas.where((m) => m.estFavori.value).length, 5);
      expect(import.mangas[0].genre.value, 'Action,Romance');
      expect(import.mangas[10].note.value, 10.0);
    });
  });

  group('Persona 4 — Karim, power user (300 mangas complets)', () {
    test('tous les champs préservés, liens valides gardés', () {
      final liens = liensToJson(const [
        Lien(nom: 'Scan', url: 'https://exemple.com/scan'),
        Lien(nom: 'Officiel', url: 'https://editeur.fr'),
      ]);
      final date = DateTime(2026, 6, 15, 14, 30);
      final mangas = List.generate(300, (i) => fabriqueManga(
            id: i + 1,
            titre: 'Titre complet $i',
            description: 'Description longue du manga numéro $i. ' * 10,
            genre: 'Action,Adventure,Fantasy',
            note: 8.5,
            chapitres: i * 3.5,
            liens: liens,
            anilistId: 30000 + i,
            lastSyncedAt: date,
            imageSource: 'anilist',
          ));
      final import = importerDepuisJson(exporterEnJson(mangas, [], []));
      expect(import.mangas.length, 300);
      final premier = import.mangas.first;
      expect(premier.anilistId.value, 30000);
      expect(premier.lastSyncedAt.value, date);
      expect(liensFromJson(premier.liens.value).length, 2);
    });
  });

  group('Persona 5 — Yuki, extrême (1500 mangas)', () {
    test('aller-retour complet en moins de 5 secondes', () {
      final mangas = List.generate(1500, (i) => fabriqueManga(
            id: i + 1,
            titre: 'マンガ $i',
            description: 'Desc $i',
            genre: 'Action,Isekai',
            chapitres: i.toDouble(),
          ));
      final chrono = Stopwatch()..start();
      final json = exporterEnJson(mangas, [], []);
      final import = importerDepuisJson(json);
      chrono.stop();
      expect(import.mangas.length, 1500);
      expect(chrono.elapsedMilliseconds, lessThan(5000));
    });
  });

  group('Persona 6 — Amir, titres internationaux', () {
    test('unicode, emoji, RTL et titres extrêmes survivent', () {
      final mangas = [
        fabriqueManga(titre: '進撃の巨人'),
        fabriqueManga(id: 2, titre: '나 혼자만 레벨업'),
        fabriqueManga(id: 3, titre: 'قصة مانغا'),
        fabriqueManga(id: 4, titre: '💀 Skeleton Soldier 💀'),
        fabriqueManga(id: 5, titre: "L'Attaque des Titans — tome \"spécial\""),
        fabriqueManga(id: 6, titre: 'A' * 500),
      ];
      final import = importerDepuisJson(exporterEnJson(mangas, [], []));
      expect(import.mangas[0].titre.value, '進撃の巨人');
      expect(import.mangas[1].titre.value, '나 혼자만 레벨업');
      expect(import.mangas[2].titre.value, 'قصة مانغا');
      expect(import.mangas[3].titre.value, '💀 Skeleton Soldier 💀');
      expect(import.mangas[4].titre.value, "L'Attaque des Titans — tome \"spécial\"");
      expect(import.mangas[5].titre.value.length, 500);
    });
  });

  group('Persona 7 — Chloé, genres et types personnalisés', () {
    test('les tags perso voyagent avec la bibliothèque', () {
      final mangas = [
        fabriqueManga(titre: 'Solo Leveling', typeManga: 'Webtoon', genre: 'Action,LitRPG'),
      ];
      final json = exporterEnJson(mangas, ['LitRPG'], ['Webtoon']);
      final import = importerDepuisJson(json);
      expect(import.customGenres, ['LitRPG']);
      expect(import.customTypes, ['Webtoon']);
      expect(import.mangas[0].typeManga.value, 'Webtoon');
      expect(import.mangas[0].genre.value, 'Action,LitRPG');
    });
  });

  group('Persona 8 — Marc, ancien export v1 (tableau brut)', () {
    test('le format historique reste importable', () {
      final json = jsonEncode([
        {'titre': 'Vieux manga', 'status': 'Terminé', 'note': 7, 'chapitres': 42},
      ]);
      final import = importerDepuisJson(json);
      expect(import.mangas.length, 1);
      expect(import.mangas[0].titre.value, 'Vieux manga');
      expect(import.customGenres, isEmpty);
    });
  });

  group('Persona 9 — Jade, fichier abîmé', () {
    test('les valeurs aberrantes sont corrigées silencieusement', () {
      final json = jsonEncode({
        'mangas': [
          {
            'titre': '  Manga louche  ',
            'note': 999,
            'chapitres': -50,
            'liens': liensToJson(const [
              Lien(nom: 'Piège', url: 'javascript:alert(1)'),
              Lien(nom: 'Sain', url: 'https://ok.fr'),
            ]),
            'imagePath': 'C:/chemin/inexistant/image.png',
            'imageSource': 'nimporte quoi',
            'anilistId': 12.7,
          },
        ],
      });
      final manga = importerDepuisJson(json).mangas.single;
      expect(manga.titre.value, 'Manga louche');
      expect(manga.note.value, 10.0);
      expect(manga.chapitres.value, 0.0);
      expect(liensFromJson(manga.liens.value).map((l) => l.nom), ['Sain']);
      expect(manga.imagePath.value, isNull);
      expect(manga.imageSource.value, 'aucune');
      expect(manga.anilistId.value, 12);
    });

    test('un manga sans titre rejette le fichier entier', () {
      final json = jsonEncode({
        'mangas': [
          {'titre': 'Valide'},
          {'note': 5},
        ],
      });
      expect(() => importerDepuisJson(json), throwsFormatException);
    });

    test('un contenu non-JSON est rejeté proprement', () {
      expect(() => importerDepuisJson('pas du json'), throwsFormatException);
      expect(() => importerDepuisJson('42'), throwsFormatException);
      expect(importerDepuisJson('{"custom_genres": ["X", 12, null]}').customGenres, ['X']);
    });
  });

  group('Persona 10 — Nina, fusion de tags à l\'import', () {
    late ProviderContainer container;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({
        'custom_genres': ['LitRPG'],
      });
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('doublons ignorés, virgules nettoyées, existants conservés', () async {
      final notifier = container.read(customGenresProvider.notifier);
      await notifier.load();

      await notifier.add('LitRPG');
      await notifier.add('Webtoon, Coréen');
      await notifier.add('   ');

      expect(container.read(customGenresProvider), ['LitRPG', 'Webtoon Coréen']);
    });
  });

  group('Image existante', () {
    test('un chemin d\'image valide est conservé', () async {
      final temp = File('${Directory.systemTemp.path}/folio_test_cover.png');
      await temp.writeAsString('fake');
      addTearDown(() => temp.delete());

      final json = jsonEncode({
        'mangas': [
          {'titre': 'Avec image', 'imagePath': temp.path, 'imageSource': 'utilisateur'},
        ],
      });
      final manga = importerDepuisJson(json).mangas.single;
      expect(manga.imagePath.value, temp.path);
      expect(manga.imageSource.value, 'utilisateur');
    });
  });
}
