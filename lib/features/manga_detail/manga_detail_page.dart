import 'dart:io';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/data/database/app_database.dart';

const List<Color> _pastelColors = [
  Color(0xFFFFB3BA),
  Color(0xFFFFDFBA),
  Color(0xFFFFFFBA),
  Color(0xFFBAFFBA),
  Color(0xFFBAE1FF),
  Color(0xFFD4BAFF),
];

class MangaDetailPage extends ConsumerStatefulWidget {
  final MangaTableData mangaData;
  const MangaDetailPage({super.key, required this.mangaData});

  @override
  ConsumerState<MangaDetailPage> createState() => _MangaDetailPage();
}

class _MangaDetailPage extends ConsumerState<MangaDetailPage> {
  late bool _estFavori;

  @override
  void initState() {
    super.initState();
    _estFavori = widget.mangaData.estFavori;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mangaData.titre),
        actions: [
          IconButton(
            onPressed: () async {
              final dao = ref.read(mangaDaoProvider);
              await dao.updateMangaByElement(
                widget.mangaData.id,
                MangaTableCompanion(estFavori: Value(!_estFavori)),
              );
              setState(() {
                _estFavori = !_estFavori;
              });
              ref.invalidate(mangasProvider);
            },
            icon: Icon(
              _estFavori ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  widget.mangaData.imagePath != null
                      ? Image.file(
                          File(widget.mangaData.imagePath!),
                          fit: BoxFit.cover,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color:
                                _pastelColors[widget.mangaData.id %
                                    _pastelColors.length],
                            height: 300,
                            width: double.infinity,
                          ),
                        ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      widget.mangaData.titre,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(flex: 1, child: Divider()),
                  SizedBox(width: 8),
                  Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Expanded(flex: 8, child: Divider()),
                ],
              ),

              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    widget.mangaData.description ?? "Aucune Desciption",
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(flex: 1, child: Divider()),
                  SizedBox(width: 8),
                  Text('Genre', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Expanded(flex: 8, child: Divider()),
                ],
              ),
              if ((widget.mangaData.genre ?? '').isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: [
                    for (String genre in (widget.mangaData.genre ?? '').split(
                      ',',
                    ))
                      Chip(label: Text(genre)),
                  ],
                )
              else
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Aucun(s) genre(s) sélectionné(s)",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(flex: 1, child: Divider()),
                  SizedBox(width: 8),
                  Text(
                    'Informations',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Expanded(flex: 8, child: Divider()),
                ],
              ),
              ListTile(
                leading: Icon(Icons.category_outlined),
                title: Text('Type'),
                trailing: Text(widget.mangaData.typeManga),
                contentPadding: EdgeInsets.zero,
              ),

              ListTile(
                leading: Icon(Icons.bookmark_outline),
                title: Text('Statut'),
                trailing: Text(widget.mangaData.status),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                leading: Icon(Icons.menu_book_outlined),
                title: Text('Chapitres'),
                trailing: Text('${widget.mangaData.chapitres}'),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                leading: Icon(Icons.star_outline, color: AppColors.stars),
                title: Text('Note'),
                trailing: Text('${widget.mangaData.note} / 10'),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
