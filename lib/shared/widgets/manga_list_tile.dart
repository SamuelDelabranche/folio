import 'dart:io';

import 'package:flutter/material.dart';
import 'package:folio/generated/app_localizations.dart';
import 'package:folio/app/constants.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/data/database/app_database.dart';

class MangaListTile extends StatelessWidget {
  final MangaTableData mangaData;

  const MangaListTile({
    super.key,
    required this.mangaData,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final couleurStatut = AppColors.couleurStatut(mangaData.status);
    final pastel = AppColors.pastels[mangaData.id % AppColors.pastels.length];

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 46,
                height: 62,
                child: mangaData.imagePath != null
                    ? Image.file(
                        File(mangaData.imagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _VignettePastel(
                          pastel: pastel,
                          titre: mangaData.titre,
                        ),
                      )
                    : _VignettePastel(pastel: pastel, titre: mangaData.titre),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mangaData.titre,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (mangaData.estFavori)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Icons.favorite, size: 14, color: AppColors.accent),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: couleurStatut.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusLabel(mangaData.status, l10n),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: couleurStatut,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.star, size: 12, color: AppColors.couleurNote(mangaData.note)),
                      const SizedBox(width: 2),
                      Text(
                        '${mangaData.note}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.couleurNote(mangaData.note),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${mangaData.chapitres.toInt()} ch.',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VignettePastel extends StatelessWidget {
  final Color pastel;
  final String titre;

  const _VignettePastel({required this.pastel, required this.titre});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: pastel,
      child: Center(
        child: Text(
          titre.isEmpty ? '?' : titre[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

class MangaCompactTile extends StatelessWidget {
  final MangaTableData mangaData;

  const MangaCompactTile({super.key, required this.mangaData});

  @override
  Widget build(BuildContext context) {
    final couleurStatut = AppColors.couleurStatut(mangaData.status);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: couleurStatut, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                mangaData.titre,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (mangaData.estFavori)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.favorite, size: 13, color: AppColors.accent),
              ),
            Text(
              '${mangaData.chapitres.toInt()} ch.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.couleurNote(mangaData.note),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${mangaData.note}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
