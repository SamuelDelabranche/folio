import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:folio/app/constants.dart';

class AddMangaPage extends ConsumerStatefulWidget {
  const AddMangaPage({super.key});

  @override
  ConsumerState<AddMangaPage> createState() => _AddMangaPageState();
}

class _AddMangaPageState extends ConsumerState<AddMangaPage> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _chapitreController = TextEditingController();
  final _rechercheController = TextEditingController();
  String _rechercheGenre = '';
  String _statusSelectionne = 'En cours';
  String _typeSelectionne = 'Manga';
  final List<String> _genreSelectionne = [];
  bool _estFavori = false;
  double _note = 5.0;

  @override
  void dispose() {
    _titreController.dispose();
    _chapitreController.dispose();
    _rechercheController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un manga')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Titre ──
              TextFormField(
                controller: _titreController,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration('Titre du manga', icon: Icons.auto_stories_outlined),
                validator: (value) => (value == null || value.isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),

              // ── Chapitres ──
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _chapitreController,
                decoration: _inputDecoration('Chapitres lus', icon: Icons.menu_book_outlined),
                validator: (value) => (value == null || value.isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 24),

              // ── Note ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Note', style: TextStyle(fontWeight: FontWeight.w500)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color.lerp(Colors.black, Colors.green, _note / 10)!.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_note.toStringAsFixed(1)} / 10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.lerp(Colors.black, Colors.green, _note / 10),
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _note,
                min: 0,
                max: 10,
                divisions: 20,
                onChanged: (value) => setState(() => _note = value),
              ),
              const SizedBox(height: 8),

              // ── Type ──
              const Text('Type', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Manga', 'Manhwa', 'Manhua', 'Novel'].map((type) {
                  final selected = _typeSelectionne == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: selected,
                    onSelected: (_) => setState(() => _typeSelectionne = type),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // ── Statut ──
              const Text('Statut', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['À lire', 'En cours', 'Terminé', 'Abandonné'].map((statut) {
                  final selected = _statusSelectionne == statut;
                  return ChoiceChip(
                    label: Text(statut),
                    selected: selected,
                    onSelected: (_) => setState(() => _statusSelectionne = statut),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // ── Genres ──
              ExpansionTile(
                title: Text(
                  _genreSelectionne.isEmpty
                      ? 'Genres'
                      : 'Genres (${_genreSelectionne.length})',
                ),
                tilePadding: EdgeInsets.zero,
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
                                  selected
                                      ? _genreSelectionne.add(genre)
                                      : _genreSelectionne.remove(genre);
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              const SizedBox(height: 8),

              // ── Favori ──
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _estFavori ? Colors.red.shade400 : Colors.grey.shade400,
                    side: BorderSide(
                      color: _estFavori ? Colors.red.shade300 : Colors.grey.shade400,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => setState(() => _estFavori = !_estFavori),
                  icon: Icon(_estFavori ? Icons.favorite : Icons.favorite_border),
                  label: Text(_estFavori ? 'Dans vos favoris' : 'Ajouter aux favoris'),
                ),
              ),
              const SizedBox(height: 24),

              // ── Bouton ──
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final dao = ref.read(mangaDaoProvider);
                    dao.insertManga(
                      MangaTableCompanion(
                        id: Value.absent(),
                        titre: Value(_titreController.text),
                        description: Value.absent(),
                        imagePath: Value.absent(),
                        status: Value(_statusSelectionne),
                        typeManga: Value(_typeSelectionne),
                        estFavori: Value(_estFavori),
                        note: Value(_note),
                        chapitres: Value(double.parse(_chapitreController.text)),
                        genre: Value(_genreSelectionne.join(',')),
                      ),
                    );
                    Navigator.pop(context);
                    ref.invalidate(mangasProvider);
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Ajouter'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
