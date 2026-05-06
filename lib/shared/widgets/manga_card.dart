import 'package:flutter/material.dart';
import 'package:folio/data/database/app_database.dart';

class MangaCard extends StatelessWidget {
  final MangaTableData mangaData;

  const MangaCard({super.key, required this.mangaData});

  Color _couleurNote(double note) {
    return Color.lerp(Colors.black, Colors.green, note / 10)!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Colors.deepPurple.shade200,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _couleurNote(mangaData.note),
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
                      color: Colors.red,
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
