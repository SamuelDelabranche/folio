import 'dart:io';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/app/constants.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/data/database/daos/manga_dao.dart';

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
  late MangaDao _dao;

  late bool _estFavori;
  bool _modeEdition = false;
  late List<String> _genreSelectionne;
  String _rechercheGenre = '';
  late String _titre;

  final _rechercheController = TextEditingController();
  late TextEditingController _titreController;
  late TextEditingController _chapitresController;
  late TextEditingController _noteController;
  late TextEditingController _descriptionController;
  late String _statutController;
  late String _typeController;

  @override
  void initState() {
    super.initState();

    _dao = ref.read(mangaDaoProvider);

    _estFavori = widget.mangaData.estFavori;
    _titre = widget.mangaData.titre;
    _titreController = TextEditingController(text: widget.mangaData.titre);
    _descriptionController = TextEditingController(
      text: widget.mangaData.description,
    );
    _chapitresController = TextEditingController(
      text: (widget.mangaData.chapitres).toString(),
    );
    _noteController = TextEditingController(
      text: (widget.mangaData.note).toString(),
    );
    _statutController = widget.mangaData.status;
    _typeController = widget.mangaData.typeManga;

    _genreSelectionne = (widget.mangaData.genre ?? '').isEmpty
        ? []
        : widget.mangaData.genre!.split(',');
  }

  @override
  void dispose() {
    _titreController.dispose();
    _chapitresController.dispose();
    _noteController.dispose();
    _descriptionController.dispose();
    _rechercheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_modeEdition) {
          if (_modeEdition) {
            final mangaMisAJour = widget.mangaData.copyWith(
              titre: _titreController.text,
              description: Value(_descriptionController.text),
              chapitres: double.parse(_chapitresController.text),
              note: double.parse(_noteController.text),
              status: _statutController,
              typeManga: _typeController,
              genre: Value(_genreSelectionne.join(',')),
            );
            await _dao.updateManga(mangaMisAJour);
            ref.invalidate(mangasProvider);
          }
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titre),
          actions: [
            IconButton(
              onPressed: () async {
                setState(() {
                  _estFavori = !_estFavori;
                });
                await _dao.updateMangaByElement(
                  widget.mangaData.id,
                  MangaTableCompanion(estFavori: Value(_estFavori)),
                );
                ref.invalidate(mangasProvider);
              },
              icon: Icon(
                _estFavori ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () async {
                if (_modeEdition) {
                  final mangaMisAJour = widget.mangaData.copyWith(
                    titre: _titreController.text,
                    description: Value(_descriptionController.text),
                    chapitres: double.parse(_chapitresController.text),
                    note: double.parse(_noteController.text),
                    status: _statutController,
                    typeManga: _typeController,
                    genre: Value(_genreSelectionne.join(',')),
                  );
                  await _dao.updateManga(mangaMisAJour);
                  ref.invalidate(mangasProvider);
                }
                setState(() {
                  _modeEdition = !_modeEdition;
                  _titre = _titreController.text;
                });
              },
              icon: Icon(_modeEdition ? Icons.check : Icons.edit),
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
                      child: _modeEdition
                          ? TextFormField(
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              controller: _titreController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            )
                          : Text(
                              _titre,
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

                _modeEdition
                    ? TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                    : Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            _descriptionController.text.isEmpty
                                ? "Aucune Description"
                                : _descriptionController.text,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                SizedBox(height: 16),
                _modeEdition
                    ? ExpansionTile(
                        title: Text(
                          "Genres (${_genreSelectionne.length}) sélectionnés",
                        ),
                        children: [
                          TextField(
                            controller: _rechercheController,
                            decoration: InputDecoration(
                              labelText: "Rechercher un genre",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _rechercheGenre = value.toLowerCase();
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            children: tousLesGenres
                                .where(
                                  (g) =>
                                      g.toLowerCase().contains(_rechercheGenre),
                                )
                                .map(
                                  (genre) => FilterChip(
                                    label: Text(genre),
                                    selected: _genreSelectionne.contains(genre),
                                    onSelected: (selected) {
                                      setState(() {
                                        selected
                                            ? _genreSelectionne.add(genre)
                                            : _genreSelectionne.remove(genre);
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 1, child: Divider()),
                              SizedBox(width: 8),
                              Text(
                                'Genre',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 8),
                              Expanded(flex: 8, child: Divider()),
                            ],
                          ),
                          if (_genreSelectionne.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              children: [
                                for (String genre in _genreSelectionne)
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
                        ],
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
                _modeEdition
                    ? Column(
                        children: [
                          SizedBox(height: 16),
                          DropdownButtonFormField(
                            initialValue: widget.mangaData.typeManga,
                            decoration: InputDecoration(
                              labelText: 'Type',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: ['Manga', 'Manhwa', 'Manhua', 'Novel']
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _typeController = value!;
                              });
                            },
                          ),
                        ],
                      )
                    : ListTile(
                        leading: Icon(Icons.category_outlined),
                        title: Text('Type'),
                        trailing: Text(_typeController),
                        contentPadding: EdgeInsets.zero,
                      ),

                _modeEdition
                    ? Column(
                        children: [
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: widget.mangaData.status,
                            decoration: InputDecoration(
                              labelText: 'Statut',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items:
                                ['À lire', 'En cours', 'Terminé', 'Abandonné']
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                _statutController = value!;
                              });
                            },
                          ),
                        ],
                      )
                    : ListTile(
                        leading: Icon(Icons.bookmark_outline),
                        title: Text('Statut'),
                        trailing: Text(_statutController),
                        contentPadding: EdgeInsets.zero,
                      ),

                _modeEdition
                    ? Column(
                        children: [
                          SizedBox(height: 16),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            controller: _chapitresController,
                            decoration: InputDecoration(
                              labelText: 'Chapitres',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListTile(
                        leading: Icon(Icons.menu_book_outlined),
                        title: Text('Chapitres'),
                        trailing: Text('${_chapitresController.text}'),
                        contentPadding: EdgeInsets.zero,
                      ),
                _modeEdition
                    ? Column(
                        children: [
                          SizedBox(height: 16),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            controller: _noteController,
                            decoration: InputDecoration(
                              labelText: 'Note',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListTile(
                        leading: Icon(Icons.stars),
                        title: Text('Notes'),
                        trailing: Text('${_noteController.text}'),
                        contentPadding: EdgeInsets.zero,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
