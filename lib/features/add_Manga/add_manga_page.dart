import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:folio/app/constants.dart';
import 'package:folio/data/models/lien.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/shared/widgets/lien_dialog.dart';

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
  final List<Lien> _liens = [];
  bool _estFavori = false;
  double _note = 5.0;

  @override
  void dispose() {
    _titreController.dispose();
    _chapitreController.dispose();
    _rechercheController.dispose();
    super.dispose();
  }

  Future<void> _ajouterLien() async {
    final lien = await showAjouterLienDialog(context);
    if (lien != null) setState(() => _liens.add(lien));
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
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Champ requis';
                  final n = double.tryParse(value.replaceAll(',', '.'));
                  if (n == null || n < 0) return 'Nombre invalide';
                  return null;
                },
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
                      color: AppColors.couleurNote(_note).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_note.toStringAsFixed(1)} / 10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.couleurNote(_note),
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

              // ── Liens ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _liens.isEmpty ? 'Liens d\'accès' : 'Liens d\'accès (${_liens.length})',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextButton.icon(
                    onPressed: _ajouterLien,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Ajouter'),
                  ),
                ],
              ),
              if (_liens.isNotEmpty) ...[
                const SizedBox(height: 4),
                ...List.generate(_liens.length, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.link, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_liens[i].nom, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                            Text(_liens[i].url, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => _liens.removeAt(i)),
                      ),
                    ],
                  ),
                )),
              ],
              const SizedBox(height: 16),

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
                        chapitres: Value(double.tryParse(_chapitreController.text.replaceAll(',', '.')) ?? 0),
                        genre: Value(_genreSelectionne.join(',')),
                        liens: Value(liensToJson(_liens)),
                      ),
                    );
                    Navigator.pop(context);
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
