

import 'package:flutter/material.dart';
import 'package:folio/domain/models/manga.dart';

class MangaDetailPage extends StatelessWidget{
  final Manga manga;

  const MangaDetailPage({super.key, required this.manga});
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(manga.titre),
        ),

        body: Center(
          child: Text(manga.titre),
        ),
      );
  }
}