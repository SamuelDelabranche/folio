

import 'package:flutter/material.dart';
import 'package:folio/data/database/app_database.dart';

class MangaDetailPage extends StatelessWidget{
  final MangaTableData mangaData;

  const MangaDetailPage({super.key, required this.mangaData});
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(mangaData.titre),
        ),

        body: Center(
          child: Text(mangaData.titre),
        ),
      );
  }
}