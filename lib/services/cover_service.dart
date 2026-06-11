import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Uint8List? _recompresserImage(Uint8List octets) {
  final decodee = img.decodeImage(octets);
  if (decodee == null) return null;
  final redimensionnee = decodee.width > CoverService.largeurMax
      ? img.copyResize(decodee, width: CoverService.largeurMax)
      : decodee;
  return Uint8List.fromList(img.encodeJpg(redimensionnee, quality: 85));
}

class CoverService {
  static const tailleMaxOctets = 10 * 1024 * 1024;

  static const largeurMax = 800;

  static Future<Directory> dossierCovers() async {
    final docs = await getApplicationDocumentsDirectory();
    final dossier = Directory('${docs.path}${Platform.pathSeparator}covers');
    if (!dossier.existsSync()) dossier.createSync(recursive: true);
    return dossier;
  }

  static Future<String> installerCover(Uint8List octets, String nomFichier) async {
    if (octets.length > tailleMaxOctets) {
      throw const CoverInvalideException('Image trop volumineuse (max 10 Mo)');
    }

    final jpeg = await compute(_recompresserImage, octets);
    if (jpeg == null) {
      throw const CoverInvalideException('Fichier illisible ou format non supporté');
    }

    final dossier = await dossierCovers();
    final cible = File('${dossier.path}${Platform.pathSeparator}$nomFichier');
    final temp = File('${cible.path}.tmp');
    await temp.writeAsBytes(jpeg, flush: true);
    if (cible.existsSync()) await cible.delete();
    await temp.rename(cible.path);
    return cible.path;
  }

  static Future<void> supprimerCover(String? imagePath) async {
    if (imagePath == null) return;
    final dossier = await dossierCovers();
    if (!imagePath.startsWith(dossier.path)) return;
    final fichier = File(imagePath);
    if (fichier.existsSync()) await fichier.delete();
  }

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
