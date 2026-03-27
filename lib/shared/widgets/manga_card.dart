import 'package:flutter/material.dart';
import 'package:folio/data/database/app_database.dart';

class MangaCard extends StatelessWidget{
  final MangaTableData mangaData;
  
  const MangaCard({super.key, required this.mangaData});

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
                Text(mangaData.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("${mangaData.chapitres} ch. · ⭐ ${mangaData.note}"),
              ],
            ),
          ),
        ],
      ),
    );

  }
}