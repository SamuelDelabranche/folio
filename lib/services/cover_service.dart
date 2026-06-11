import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// Décode, redimensionne et ré-encode en JPEG. Tourne dans un isolate via
/// [compute] : le décodage d'une photo de plusieurs Mo figerait l'UI sinon.
/// Retourne null si le fichier n'est pas une image valide.
Uint8List? _recompresserImage(Uint8List octets) {
  final decodee = img.decodeImage(octets);
  if (decodee == null) return null;
  final redimensionnee = decodee.width > CoverService.largeurMax
      ? img.copyResize(decodee, width: CoverService.largeurMax)
      : decodee;
  return Uint8List.fromList(img.encodeJpg(redimensionnee, quality: 85));
}

/// Gestion des images de couverture stockées par l'app.
///
/// Tout fichier entrant (galerie ou téléchargement) est traité comme hostile :
/// limite de taille, décodage de vérification, recompression, nom de fichier
/// généré par l'app. Voir docs/ANILIST_SYNC.md (garde-fous).
class CoverService {
  /// Taille maximale acceptée avant décodage.
  static const tailleMaxOctets = 10 * 1024 * 1024;

  /// Largeur maximale après recompression (suffisant pour un affichage
  /// plein écran de fiche, et léger pour la grille).
  static const largeurMax = 800;

  /// Dossier `covers/` dans les documents de l'app (créé si absent).
  static Future<Directory> dossierCovers() async {
    final docs = await getApplicationDocumentsDirectory();
    final dossier = Directory('${docs.path}${Platform.pathSeparator}covers');
    if (!dossier.existsSync()) dossier.createSync(recursive: true);
    return dossier;
  }

  /// Valide, recompresse et installe une image dans `covers/`.
  ///
  /// [octets] : contenu brut du fichier source (galerie ou réseau).
  /// [nomFichier] : nom cible généré par l'appelant (ex. `cover_12.jpg`) —
  /// jamais un nom venant de l'extérieur.
  ///
  /// Retourne le chemin absolu du fichier installé, ou lève une
  /// [CoverInvalideException] si le fichier n'est pas une image valide.
  static Future<String> installerCover(Uint8List octets, String nomFichier) async {
    if (octets.length > tailleMaxOctets) {
      throw const CoverInvalideException('Image trop volumineuse (max 10 Mo)');
    }

    // Décodage réel : un fichier renommé en .jpg qui n'en est pas un
    // est rejeté ici, quel que soit son nom ou son extension.
    final jpeg = await compute(_recompresserImage, octets);
    if (jpeg == null) {
      throw const CoverInvalideException('Fichier illisible ou format non supporté');
    }

    // Écriture temporaire puis renommage : si quoi que ce soit échoue,
    // l'éventuelle ancienne cover reste intacte.
    final dossier = await dossierCovers();
    final cible = File('${dossier.path}${Platform.pathSeparator}$nomFichier');
    final temp = File('${cible.path}.tmp');
    await temp.writeAsBytes(jpeg, flush: true);
    if (cible.existsSync()) await cible.delete();
    await temp.rename(cible.path);
    return cible.path;
  }

  /// Supprime la cover d'un manga si elle est dans notre dossier `covers/`.
  /// Les chemins extérieurs (anciens imports) sont laissés tranquilles.
  static Future<void> supprimerCover(String? imagePath) async {
    if (imagePath == null) return;
    final dossier = await dossierCovers();
    if (!imagePath.startsWith(dossier.path)) return;
    final fichier = File(imagePath);
    if (fichier.existsSync()) await fichier.delete();
  }

  /// Vide entièrement le dossier `covers/` (action « Tout effacer »).
  static Future<void> toutSupprimer() async {
    final dossier = await dossierCovers();
    if (dossier.existsSync()) {
      await dossier.delete(recursive: true);
    }
  }
}

class CoverInvalideException implements Exception {
  final String message;
  const CoverInvalideException(this.message);

  @override
  String toString() => message;
}
