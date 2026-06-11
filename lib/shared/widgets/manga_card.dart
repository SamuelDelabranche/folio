import 'dart:io';

import 'package:flutter/material.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/data/database/app_database.dart';

class MangaCard extends StatelessWidget {
  final MangaTableData mangaData;

  const MangaCard({super.key, required this.mangaData});

  @override
  Widget build(BuildContext context) {
    final couleurStatut = AppColors.couleurStatut(mangaData.status);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                if (mangaData.imagePath != null)
                  Positioned.fill(
                    child: Image.file(
                      File(mangaData.imagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: AppColors.pastels[mangaData.id % AppColors.pastels.length],
                      ),
                    ),
                  )
                else
                  Container(
                    color: AppColors.pastels[mangaData.id % AppColors.pastels.length],
                    width: double.infinity,
                    height: double.infinity,
                  ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: couleurStatut,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      mangaData.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.couleurNote(mangaData.note),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${mangaData.note}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mangaData.titre,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      mangaData.estFavori
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: AppColors.accent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${mangaData.chapitres.toInt()} ch.",
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
