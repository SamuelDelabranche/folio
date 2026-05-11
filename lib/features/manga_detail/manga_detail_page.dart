import 'dart:io';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/app/constants.dart';
import 'package:folio/app/theme.dart';
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
  late double _noteEdition;

  final _rechercheController = TextEditingController();
  late TextEditingController _titreController;
  late TextEditingController _chapitresController;
  late TextEditingController _descriptionController;
  late String _statutController;
  late String _typeController;

  @override
  void initState() {
    super.initState();
    _dao = ref.read(mangaDaoProvider);
    _estFavori = widget.mangaData.estFavori;
    _titre = widget.mangaData.titre;
    _noteEdition = widget.mangaData.note;
    _titreController = TextEditingController(text: widget.mangaData.titre);
    _descriptionController = TextEditingController(text: widget.mangaData.description);
    _chapitresController = TextEditingController(text: widget.mangaData.chapitres.toString());
    _statutController = ['À lire', 'En cours', 'Terminé', 'Abandonné'].contains(widget.mangaData.status)
        ? widget.mangaData.status
        : 'Terminé';
    _typeController = widget.mangaData.typeManga;
    _genreSelectionne = (widget.mangaData.genre ?? '').isEmpty
        ? []
        : widget.mangaData.genre!.split(',');
  }

  @override
  void dispose() {
    _titreController.dispose();
    _chapitresController.dispose();
    _descriptionController.dispose();
    _rechercheController.dispose();
    super.dispose();
  }

  Future<void> _sauvegarder() async {
    final mangaMisAJour = widget.mangaData.copyWith(
      titre: _titreController.text,
      description: Value(_descriptionController.text),
      chapitres: double.tryParse(_chapitresController.text) ?? widget.mangaData.chapitres,
      note: _noteEdition,
      status: _statutController,
      typeManga: _typeController,
      genre: Value(_genreSelectionne.join(',')),
    );
    await _dao.updateManga(mangaMisAJour);
    ref.invalidate(mangasProvider);
  }

  Color _couleurNote(double note) => Color.lerp(Colors.black, Colors.green, note / 10)!;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final nav = Navigator.of(context);
        if (_modeEdition) await _sauvegarder();
        nav.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titre),
          actions: [
            // Favori
            IconButton(
              onPressed: () async {
                setState(() => _estFavori = !_estFavori);
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
            // Edition
            IconButton(
              onPressed: () async {
                if (_modeEdition) {
                  await _sauvegarder();
                  setState(() {
                    _modeEdition = false;
                    _titre = _titreController.text;
                  });
                } else {
                  setState(() => _modeEdition = true);
                }
              },
              icon: Icon(_modeEdition ? Icons.check : Icons.edit_outlined),
            ),
            // Suppression
            IconButton(
              onPressed: () {
                final nav = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    icon: Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 48),
                    title: Text('Attention !', style: TextStyle(color: AppColors.danger)),
                    content: const Text(
                      'Cette action est irréversible.\nLe manga sera définitivement supprimé.',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                        onPressed: () async {
                          await _dao.deleteManga(widget.mangaData.id);
                          ref.invalidate(mangasProvider);
                          messenger.showSnackBar(SnackBar(
                            backgroundColor: AppColors.success,
                            content: const Text('Manga supprimé', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87)),
                          ));
                          if (mounted) { nav.pop(); nav.pop(); }
                        },
                        child: Text('Supprimer', style: TextStyle(color: AppColors.danger)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header image ──
              Stack(
                children: [
                  widget.mangaData.imagePath != null
                      ? Image.file(File(widget.mangaData.imagePath!), fit: BoxFit.cover, width: double.infinity, height: 260)
                      : Container(
                          color: _pastelColors[widget.mangaData.id % _pastelColors.length],
                          height: 260,
                          width: double.infinity,
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
                            controller: _titreController,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(12)),
                            ),
                          )
                        : Text(
                            _titre,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Description ──
                    _SectionLabel('Description'),
                    _modeEdition
                        ? TextField(
                            controller: _descriptionController,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          )
                        : Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                _descriptionController.text.isEmpty ? 'Aucune description' : _descriptionController.text,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(height: 1.5),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),

                    // ── Genres ──
                    _SectionLabel('Genres'),
                    _modeEdition
                        ? ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Text('${_genreSelectionne.length} sélectionné(s)'),
                            children: [
                              TextField(
                                controller: _rechercheController,
                                decoration: InputDecoration(
                                  hintText: 'Rechercher un genre...',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  isDense: true,
                                ),
                                onChanged: (value) => setState(() => _rechercheGenre = value.toLowerCase()),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: tousLesGenres
                                    .where((g) => g.toLowerCase().contains(_rechercheGenre))
                                    .map((genre) => FilterChip(
                                          label: Text(genre),
                                          selected: _genreSelectionne.contains(genre),
                                          onSelected: (selected) {
                                            setState(() {
                                              selected ? _genreSelectionne.add(genre) : _genreSelectionne.remove(genre);
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 8),
                            ],
                          )
                        : _genreSelectionne.isEmpty
                            ? Card(
                                margin: EdgeInsets.zero,
                                child: const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: Text('Aucun genre renseigné')),
                                ),
                              )
                            : Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: _genreSelectionne.map((g) => Chip(label: Text(g))).toList(),
                              ),
                    const SizedBox(height: 20),

                    // ── Informations ──
                    _SectionLabel('Informations'),
                    _modeEdition
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Type', style: TextStyle(fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: ['Manga', 'Manhwa', 'Manhua', 'Novel'].map((type) => ChoiceChip(
                                      label: Text(type),
                                      selected: _typeController == type,
                                      onSelected: (_) => setState(() => _typeController = type),
                                    )).toList(),
                              ),
                              const SizedBox(height: 16),
                              const Text('Statut', style: TextStyle(fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: ['À lire', 'En cours', 'Terminé', 'Abandonné'].map((statut) => ChoiceChip(
                                      label: Text(statut),
                                      selected: _statutController == statut,
                                      onSelected: (_) => setState(() => _statutController = statut),
                                    )).toList(),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _chapitresController,
                                decoration: InputDecoration(
                                  labelText: 'Chapitres lus',
                                  prefixIcon: const Icon(Icons.menu_book_outlined),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Note', style: TextStyle(fontWeight: FontWeight.w500)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _couleurNote(_noteEdition).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${_noteEdition.toStringAsFixed(1)} / 10',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: _couleurNote(_noteEdition)),
                                    ),
                                  ),
                                ],
                              ),
                              Slider(
                                value: _noteEdition,
                                min: 0,
                                max: 10,
                                divisions: 20,
                                onChanged: (value) => setState(() => _noteEdition = value),
                              ),
                            ],
                          )
                        : Card(
                            margin: EdgeInsets.zero,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.category_outlined),
                                  title: const Text('Type'),
                                  trailing: Text(_typeController, style: const TextStyle(color: Colors.grey)),
                                ),
                                const Divider(height: 1, indent: 56),
                                ListTile(
                                  leading: const Icon(Icons.bookmark_outline),
                                  title: const Text('Statut'),
                                  trailing: Text(_statutController, style: const TextStyle(color: Colors.grey)),
                                ),
                                const Divider(height: 1, indent: 56),
                                ListTile(
                                  leading: const Icon(Icons.menu_book_outlined),
                                  title: const Text('Chapitres lus'),
                                  trailing: Text(_chapitresController.text, style: const TextStyle(color: Colors.grey)),
                                ),
                                const Divider(height: 1, indent: 56),
                                ListTile(
                                  leading: const Icon(Icons.star_outline),
                                  title: const Text('Note'),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _couleurNote(widget.mangaData.note).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${_noteEdition.toStringAsFixed(1)} / 10',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: _couleurNote(_noteEdition)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
