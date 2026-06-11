import 'dart:io';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/app/constants.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/data/database/daos/manga_dao.dart';
import 'package:folio/data/models/lien.dart';
import 'package:folio/features/manga_detail/lier_anilist_sheet.dart';
import 'package:folio/services/anilist/anilist_client.dart';
import 'package:folio/services/anilist/sync_service.dart';
import 'package:folio/services/cover_service.dart';
import 'package:folio/shared/widgets/lien_dialog.dart';
import 'package:image_picker/image_picker.dart';

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
  late List<Lien> _liens;
  String _rechercheGenre = '';
  late String _titre;
  late double _noteEdition;

  final _rechercheController = TextEditingController();
  late TextEditingController _titreController;
  late TextEditingController _chapitresController;
  late TextEditingController _descriptionController;
  late String _statutController;
  late String _typeController;

  late bool _syncImage;
  late bool _syncDescription;
  late bool _syncGenres;
  late bool _syncType;

  String? _imagePath;
  late String _imageSource;
  int? _anilistId;
  DateTime? _lastSyncedAt;
  bool _syncEnCours = false;

  @override
  void initState() {
    super.initState();
    _dao = ref.read(mangaDaoProvider);
    _estFavori = widget.mangaData.estFavori;
    _syncImage = widget.mangaData.syncImage;
    _syncDescription = widget.mangaData.syncDescription;
    _syncGenres = widget.mangaData.syncGenres;
    _syncType = widget.mangaData.syncType;
    _imagePath = widget.mangaData.imagePath;
    _imageSource = widget.mangaData.imageSource;
    _anilistId = widget.mangaData.anilistId;
    _lastSyncedAt = widget.mangaData.lastSyncedAt;
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
    _liens = liensFromJson(widget.mangaData.liens);
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
      liens: Value(liensToJson(_liens)),
    );
    await _dao.updateManga(mangaMisAJour);
  }

  void _copierLien(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: const Text('Lien copié', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _ajouterLien() async {
    final lien = await showAjouterLienDialog(context);
    if (lien != null) setState(() => _liens.add(lien));
  }

  Future<void> _setToggleSync(MangaTableCompanion companion) =>
      _dao.updateMangaByElement(widget.mangaData.id, companion);

  Future<void> _lier() async {
    final resultat = await showLierAnilistSheet(context, _titre);
    if (resultat == null) return;
    await _dao.updateMangaByElement(
      widget.mangaData.id,
      MangaTableCompanion(anilistId: Value(resultat.id)),
    );
    if (!mounted) return;
    setState(() => _anilistId = resultat.id);
  }

  Future<void> _synchroniserMaintenant() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _syncEnCours = true);
    try {
      var actuel = await _dao.getManga(widget.mangaData.id);
      if (actuel == null) return;
      if (actuel.anilistId == null) {
        final lie = await ref.read(syncServiceProvider).lierAuto(actuel);
        if (!lie) {
          messenger.showSnackBar(SnackBar(
            backgroundColor: AppColors.info,
            content: const Text('Aucune fiche AniList trouvée pour ce titre', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87)),
          ));
          return;
        }
        actuel = await _dao.getManga(widget.mangaData.id);
        if (actuel == null || actuel.anilistId == null) return;
      }
      await ref.read(syncServiceProvider).syncOne(actuel);
      final frais = await _dao.getManga(widget.mangaData.id);
      if (!mounted || frais == null) return;
      setState(() {
        _descriptionController.text = frais.description ?? '';
        _genreSelectionne = (frais.genre ?? '').isEmpty ? [] : frais.genre!.split(',');
        _typeController = frais.typeManga;
        _imagePath = frais.imagePath;
        _imageSource = frais.imageSource;
        _anilistId = frais.anilistId;
        _lastSyncedAt = frais.lastSyncedAt;
      });
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.success,
        content: const Text('Fiche synchronisée', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87)),
      ));
    } on AnilistRateLimitException catch (e) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.info,
        content: Text('AniList est saturé — réessaie dans ${e.retryAfter.inSeconds} s', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
      ));
    } catch (_) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.danger,
        content: const Text('Synchronisation impossible. Vérifie ta connexion.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      ));
    } finally {
      if (mounted) setState(() => _syncEnCours = false);
    }
  }

  Future<void> _delier() async {
    if (_imageSource == 'anilist') {
      await CoverService.supprimerCover(_imagePath);
    }
    await _dao.updateMangaByElement(
      widget.mangaData.id,
      MangaTableCompanion(
        anilistId: const Value(null),
        lastSyncedAt: const Value(null),
        imagePath: _imageSource == 'anilist' ? const Value(null) : Value(_imagePath),
        imageSource: _imageSource == 'anilist' ? const Value('aucune') : Value(_imageSource),
      ),
    );
    if (!mounted) return;
    setState(() {
      _anilistId = null;
      _lastSyncedAt = null;
      if (_imageSource == 'anilist') {
        _imagePath = null;
        _imageSource = 'aucune';
      }
    });
  }

  void _ouvrirMenuImage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Importer une image'),
              subtitle: const Text('Choisir depuis la galerie'),
              onTap: () {
                Navigator.pop(sheetContext);
                _importerImage();
              },
            ),
            if (_imagePath != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.danger),
                title: Text('Supprimer l\'image', style: TextStyle(color: AppColors.danger)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _supprimerImage();
                },
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _importerImage() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final fichier = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (fichier == null) return;

      if (await fichier.length() > CoverService.tailleMaxOctets) {
        throw const CoverInvalideException('Image trop volumineuse (max 10 Mo)');
      }
      final octets = await fichier.readAsBytes();
      final chemin = await CoverService.installerCover(
        octets,
        'cover_${widget.mangaData.id}.jpg',
      );

      await _dao.updateMangaByElement(
        widget.mangaData.id,
        MangaTableCompanion(
          imagePath: Value(chemin),
          imageSource: const Value('utilisateur'),
          syncImage: const Value(false),
        ),
      );
      if (!mounted) return;
      setState(() {
        _imagePath = chemin;
        _imageSource = 'utilisateur';
        _syncImage = false;
      });
      FileImage(File(chemin)).evict();
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.info,
        content: const Text(
          'Image personnalisée — la synchro de la cover est désactivée pour ce manga',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black87),
        ),
      ));
    } on CoverInvalideException catch (e) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.danger,
        content: Text(e.message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
      ));
    } catch (_) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.danger,
        content: const Text("Impossible d'importer cette image", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      ));
    }
  }

  Future<void> _supprimerImage() async {
    await CoverService.supprimerCover(_imagePath);
    await _dao.updateMangaByElement(
      widget.mangaData.id,
      const MangaTableCompanion(
        imagePath: Value(null),
        imageSource: Value('aucune'),
      ),
    );
    if (!mounted) return;
    setState(() {
      _imagePath = null;
      _imageSource = 'aucune';
    });
  }

  String _formatDate(DateTime d) {
    String deux(int n) => n.toString().padLeft(2, '0');
    return '${deux(d.day)}/${deux(d.month)}/${d.year} à ${deux(d.hour)}h${deux(d.minute)}';
  }

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
            IconButton(
              onPressed: _syncEnCours ? null : _synchroniserMaintenant,
              tooltip: 'Synchroniser',
              icon: _syncEnCours
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
            ),
            IconButton(
              onPressed: () async {
                setState(() => _estFavori = !_estFavori);
                await _dao.updateMangaByElement(
                  widget.mangaData.id,
                  MangaTableCompanion(estFavori: Value(_estFavori)),
                );
              },
              icon: Icon(
                _estFavori ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
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
                          await CoverService.supprimerCover(_imagePath);
                          await _dao.deleteManga(widget.mangaData.id);
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

              Stack(
                children: [
                  GestureDetector(
                    onTap: _ouvrirMenuImage,
                    child: _imagePath != null
                        ? Image.file(
                            File(_imagePath!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 260,
                            errorBuilder: (_, _, _) => Container(
                              color: AppColors.pastels[widget.mangaData.id % AppColors.pastels.length],
                              height: 260,
                              width: double.infinity,
                            ),
                          )
                        : Container(
                            color: AppColors.pastels[widget.mangaData.id % AppColors.pastels.length],
                            height: 260,
                            width: double.infinity,
                          ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
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
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Material(
                      color: Colors.black45,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _ouvrirMenuImage,
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.photo_camera_outlined, color: Colors.white, size: 20),
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
                                      color: AppColors.couleurNote(_noteEdition).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${_noteEdition.toStringAsFixed(1)} / 10',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.couleurNote(_noteEdition)),
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
                                      color: AppColors.couleurNote(widget.mangaData.note).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${_noteEdition.toStringAsFixed(1)} / 10',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.couleurNote(_noteEdition)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 20),

                    _SectionLabel('Liens d\'accès'),
                    _modeEdition
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < _liens.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.link, size: 18, color: Colors.grey),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(_liens[i].nom, style: const TextStyle(fontWeight: FontWeight.w500)),
                                            Text(_liens[i].url, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              iconSize: 18,
                                              icon: const Icon(Icons.keyboard_arrow_up),
                                              onPressed: i > 0 ? () => setState(() {
                                                final item = _liens.removeAt(i);
                                                _liens.insert(i - 1, item);
                                              }) : null,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              iconSize: 18,
                                              icon: const Icon(Icons.keyboard_arrow_down),
                                              onPressed: i < _liens.length - 1 ? () => setState(() {
                                                final item = _liens.removeAt(i);
                                                _liens.insert(i + 1, item);
                                              }) : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline, color: AppColors.danger),
                                        onPressed: () => setState(() => _liens.removeAt(i)),
                                      ),
                                    ],
                                  ),
                                ),
                              OutlinedButton.icon(
                                onPressed: _ajouterLien,
                                icon: const Icon(Icons.add),
                                label: const Text('Ajouter un lien'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 44),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ],
                          )
                        : _liens.isEmpty
                            ? Card(
                                margin: EdgeInsets.zero,
                                child: const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: Text('Aucun lien renseigné')),
                                ),
                              )
                            : Column(
                                children: [
                                  for (int i = 0; i < _liens.length; i++)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: InkWell(
                                        onTap: () => _copierLien(_liens[i].url),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Card(
                                          margin: EdgeInsets.zero,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 36,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(Icons.link, size: 18, color: Theme.of(context).colorScheme.primary),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(_liens[i].nom, style: const TextStyle(fontWeight: FontWeight.w600)),
                                                      const SizedBox(height: 2),
                                                      Text(_liens[i].url, style: TextStyle(fontSize: 11, color: Colors.grey.shade500), maxLines: 1, overflow: TextOverflow.ellipsis),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                    const SizedBox(height: 20),

                    if (_modeEdition) ...[
                    _SectionLabel('Synchronisation AniList'),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Consumer(
                        builder: (context, ref, _) {
                          final prefs = ref.watch(syncPrefsProvider);
                          return Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  _anilistId != null
                                      ? Icons.cloud_done_outlined
                                      : Icons.cloud_off_outlined,
                                  color: _anilistId != null
                                      ? AppColors.success
                                      : Colors.grey,
                                ),
                                title: Text(_anilistId != null
                                    ? 'Lié à AniList (#$_anilistId)'
                                    : 'Non lié à AniList'),
                                subtitle: Text(_lastSyncedAt != null
                                    ? 'Dernière synchro : ${_formatDate(_lastSyncedAt!)}'
                                    : 'Jamais synchronisé'),
                                trailing: TextButton(
                                  onPressed: _anilistId != null ? _delier : _lier,
                                  child: Text(_anilistId != null ? 'Délier' : 'Lier'),
                                ),
                              ),
                              if (_anilistId != null)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.tonalIcon(
                                      onPressed: _syncEnCours || !prefs.maitre
                                          ? null
                                          : _synchroniserMaintenant,
                                      icon: _syncEnCours
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                          : const Icon(Icons.sync, size: 18),
                                      label: Text(_syncEnCours
                                          ? 'Synchronisation…'
                                          : 'Synchroniser maintenant'),
                                    ),
                                  ),
                                ),
                              const Divider(height: 1, indent: 56),
                              _SyncToggleFiche(
                                label: 'Image de couverture',
                                value: _syncImage,
                                globalActif: prefs.maitre && prefs.image,
                                note: _imageSource == 'utilisateur'
                                    ? 'Image personnalisée — jamais écrasée par la synchro'
                                    : null,
                                onChanged: (v) {
                                  setState(() => _syncImage = v);
                                  _setToggleSync(MangaTableCompanion(syncImage: Value(v)));
                                },
                              ),
                              _SyncToggleFiche(
                                label: 'Description',
                                value: _syncDescription,
                                globalActif: prefs.maitre && prefs.description,
                                onChanged: (v) {
                                  setState(() => _syncDescription = v);
                                  _setToggleSync(MangaTableCompanion(syncDescription: Value(v)));
                                },
                              ),
                              _SyncToggleFiche(
                                label: 'Genres',
                                value: _syncGenres,
                                globalActif: prefs.maitre && prefs.genres,
                                onChanged: (v) {
                                  setState(() => _syncGenres = v);
                                  _setToggleSync(MangaTableCompanion(syncGenres: Value(v)));
                                },
                              ),
                              _SyncToggleFiche(
                                label: 'Type',
                                value: _syncType,
                                globalActif: prefs.maitre && prefs.type,
                                onChanged: (v) {
                                  setState(() => _syncType = v);
                                  _setToggleSync(MangaTableCompanion(syncType: Value(v)));
                                },
                              ),
                              const SizedBox(height: 4),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    ],
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

class _SyncToggleFiche extends StatelessWidget {
  final String label;
  final bool value;
  final bool globalActif;
  final String? note;
  final ValueChanged<bool> onChanged;

  const _SyncToggleFiche({
    required this.label,
    required this.value,
    required this.globalActif,
    required this.onChanged,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final sousTitre = !globalActif ? 'Désactivé globalement (Paramètres)' : note;
    return SwitchListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      subtitle: sousTitre == null
          ? null
          : Text(sousTitre, style: const TextStyle(fontSize: 11)),
      value: value,
      onChanged: globalActif ? onChanged : null,
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
