import 'package:flutter/material.dart';
import 'package:folio/domain/models/manga.dart';

class MangaCard extends StatelessWidget{
  final Manga manga;
  
  const MangaCard({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.deepPurple.shade200,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(manga.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("${manga.chapitres} ch. · ⭐ ${manga.note}"),
              ],
            ),
          ),
        ],
      ),
    );

  }
}