import 'package:flutter/material.dart';
import 'package:folio/generated/app_localizations.dart';
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

  Future<void> _dialogAjouterTag(String titre, Future<void> Function(String) onAdd) async {
    final l10n = AppLocalizations.of(context)!;
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titre),
        content: TextField(
          controller: ctrl,
          textCapitalization: TextCapitalization.sentences,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onSubmitted: (_) => Navigator.pop(ctx),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonAdd)),
        ],
      ),
    );
    final val = ctrl.text.trim();
    ctrl.dispose();
    if (val.isNotEmpty) await onAdd(val);
  }

  Future<void> _supprimerType(String type) async {
    final l10n = AppLocalizations.of(context)!;
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addCustomDeleteTitle),
        content: Text(type),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirme == true) {
      await ref.read(customTypesProvider.notifier).remove(type);
      if (_typeSelectionne == type) setState(() => _typeSelectionne = 'Manga');
    }
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
    final l10n = AppLocalizations.of(context)!;
    final statuses = [
      ('À lire', l10n.statusToRead),
      ('En cours', l10n.statusReading),
      ('Terminé', l10n.statusFinished),
      ('Abandonné', l10n.statusDropped),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addTitle)),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextFormField(
                controller: _titreController,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(l10n.addMangaTitle, icon: Icons.auto_stories_outlined),
                validator: (value) => (value == null || value.isEmpty) ? l10n.addRequired : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: _chapitreController,
                decoration: _inputDecoration(l10n.addChaptersRead, icon: Icons.menu_book_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) return l10n.addRequired;
                  final n = double.tryParse(value.replaceAll(',', '.'));
                  if (n == null || n < 0) return l10n.addInvalidNumber;
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.addRating, style: const TextStyle(fontWeight: FontWeight.w500)),
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

              Text(l10n.addType, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ...['Manga', 'Manhwa', 'Manhua', 'Novel', ...ref.watch(customTypesProvider)].map((type) {
                    final isCustom = ref.read(customTypesProvider).contains(type);
                    return GestureDetector(
                      onLongPress: isCustom ? () => _supprimerType(type) : null,
                      child: ChoiceChip(
                        label: Text(type),
                        selected: _typeSelectionne == type,
                        onSelected: (_) => setState(() => _typeSelectionne = type),
                      ),
                    );
                  }),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 16),
                    label: Text(l10n.addCustomType),
                    onPressed: () => _dialogAjouterTag(
                      l10n.addCustomType,
                      ref.read(customTypesProvider.notifier).add,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(l10n.addStatus, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: statuses.map<Widget>(((String, String) s) {
                  final selected = _statusSelectionne == s.$1;
                  return ChoiceChip(
                    label: Text(s.$2),
                    selected: selected,
                    onSelected: (_) => setState(() => _statusSelectionne = s.$1),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              ExpansionTile(
                title: Text(
                  _genreSelectionne.isEmpty
                      ? l10n.addGenres
                      : l10n.addGenresCount(_genreSelectionne.length),
                ),
                tilePadding: EdgeInsets.zero,
                children: [
                  TextField(
                    controller: _rechercheController,
                    decoration: InputDecoration(
                      hintText: l10n.addSearchGenre,
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
                    children: [
                      ...[...tousLesGenres, ...ref.watch(customGenresProvider)]
                          .where((g) => genreLabel(g, l10n).toLowerCase().contains(_rechercheGenre))
                          .map((genre) {
                        final isCustom = ref.read(customGenresProvider).contains(genre);
                        return FilterChip(
                          label: Text(genreLabel(genre, l10n)),
                          selected: _genreSelectionne.contains(genre),
                          onDeleted: isCustom
                              ? () => ref.read(customGenresProvider.notifier).remove(genre)
                              : null,
                          onSelected: (selected) {
                            setState(() {
                              selected
                                  ? _genreSelectionne.add(genre)
                                  : _genreSelectionne.remove(genre);
                            });
                          },
                        );
                      }),
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 16),
                        label: Text(l10n.addCustomGenre),
                        onPressed: () => _dialogAjouterTag(
                          l10n.addCustomGenre,
                          ref.read(customGenresProvider.notifier).add,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              const SizedBox(height: 8),

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
                  label: Text(_estFavori ? l10n.addFavoriteIn : l10n.addFavoriteAdd),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _liens.isEmpty ? l10n.addLinks : l10n.addLinksCount(_liens.length),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextButton.icon(
                    onPressed: _ajouterLien,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.commonAdd),
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

              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final nav = Navigator.of(context);
                    final dao = ref.read(mangaDaoProvider);
                    await dao.insertManga(
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
                    nav.pop();
                  }
                },
                icon: const Icon(Icons.check),
                label: Text(l10n.commonAdd),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
