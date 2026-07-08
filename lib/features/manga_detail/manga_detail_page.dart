import 'dart:io';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:folio/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/constants.dart';
import 'package:folio/app/providers.dart';
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
    final chapitres = double.tryParse(_chapitresController.text.replaceAll(',', '.'));
    await _dao.updateMangaByElement(
      widget.mangaData.id,
      MangaTableCompanion(
        titre: Value(_titreController.text),
        description: Value(_descriptionController.text),
        chapitres: chapitres != null && chapitres >= 0
            ? Value(chapitres)
            : const Value.absent(),
        note: Value(_noteEdition),
        status: Value(_statutController),
        typeManga: Value(_typeController),
        genre: Value(_genreSelectionne.join(',')),
        liens: Value(liensToJson(_liens)),
      ),
    );
  }

  void _copierLien(String url) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Text(l10n.detailLinkCopied, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
        duration: const Duration(seconds: 2),
      ),
    );
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
      if (_typeController == type) setState(() => _typeController = 'Manga');
    }
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
    final l10n = AppLocalizations.of(context)!;
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
            content: Text(l10n.detailSyncNoMatch, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
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
        content: Text(l10n.detailSyncSuccess, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
      ));
    } on AnilistRateLimitException catch (e) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.info,
        content: Text(AppLocalizations.of(context)!.detailSyncRateLimit(e.retryAfter.inSeconds), textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
      ));
    } catch (_) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.danger,
        content: Text(AppLocalizations.of(context)!.detailSyncError, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
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
    final l10n = AppLocalizations.of(context)!;
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
              title: Text(l10n.detailImageImport),
              subtitle: Text(l10n.detailImageGallery),
              onTap: () {
                Navigator.pop(sheetContext);
                _importerImage();
              },
            ),
            if (_imagePath != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.danger),
                title: Text(l10n.detailImageDelete, style: TextStyle(color: AppColors.danger)),
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
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final fichier = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (fichier == null) return;

      if (await fichier.length() > CoverService.tailleMaxOctets) {
        throw const CoverInvalideException('Image trop volumineuse (max 10 Mo)');
      }
      final octets = await fichier.readAsBytes();
      final chemin = await CoverService.installerCover(octets, 'cover_${widget.mangaData.id}.jpg');
      if (_imagePath != null && _imagePath != chemin) {
        await CoverService.supprimerCover(_imagePath);
      }

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
        content: Text(l10n.detailImageCustomInfo, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
      ));
    } on CoverInvalideException catch (e) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.danger,
        content: Text(e.message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
      ));
    } catch (_) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.danger,
        content: Text(AppLocalizations.of(context)!.detailImageError, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
      ));
    }
  }

  Future<void> _supprimerImage() async {
    await CoverService.supprimerCover(_imagePath);
    await _dao.updateMangaByElement(
      widget.mangaData.id,
      const MangaTableCompanion(imagePath: Value(null), imageSource: Value('aucune')),
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
    final l10n = AppLocalizations.of(context)!;
    final statuses = [
      ('À lire', l10n.statusToRead),
      ('En cours', l10n.statusReading),
      ('Terminé', l10n.statusFinished),
      ('Abandonné', l10n.statusDropped),
    ];

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
              tooltip: l10n.detailSyncNow,
              icon: _syncEnCours
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
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
              icon: Icon(_estFavori ? Icons.favorite : Icons.favorite_border, color: Colors.red),
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
                    title: Text(l10n.commonWarning, style: TextStyle(color: AppColors.danger)),
                    content: Text(l10n.detailDeleteContent, textAlign: TextAlign.center),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(l10n.commonCancel),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                        onPressed: () async {
                          await CoverService.supprimerCover(_imagePath);
                          await _dao.deleteManga(widget.mangaData.id);
                          messenger.showSnackBar(SnackBar(
                            backgroundColor: AppColors.success,
                            content: Text(l10n.detailDeleteSuccess, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
                          ));
                          if (mounted) { nav.pop(); nav.pop(); }
                        },
                        child: Text(l10n.commonDelete, style: TextStyle(color: AppColors.danger)),
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

                    _SectionLabel(l10n.detailDescription),
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
                                _descriptionController.text.isEmpty ? l10n.detailNoDescription : _descriptionController.text,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(height: 1.5),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),

                    _SectionLabel(l10n.detailGenres),
                    _modeEdition
                        ? ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Text(l10n.detailSelectedCount(_genreSelectionne.length)),
                            children: [
                              TextField(
                                controller: _rechercheController,
                                decoration: InputDecoration(
                                  hintText: l10n.detailSearchGenre,
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
                                          selected ? _genreSelectionne.add(genre) : _genreSelectionne.remove(genre);
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
                          )
                        : _genreSelectionne.isEmpty
                            ? Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(child: Text(l10n.detailNoGenre)),
                                ),
                              )
                            : Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: _genreSelectionne.map((g) => Chip(label: Text(genreLabel(g, l10n)))).toList(),
                              ),
                    const SizedBox(height: 20),

                    _SectionLabel(l10n.detailInfo),
                    _modeEdition
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.detailType, style: const TextStyle(fontWeight: FontWeight.w500)),
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
                                        selected: _typeController == type,
                                        onSelected: (_) => setState(() => _typeController = type),
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
                              Text(l10n.detailStatus, style: const TextStyle(fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: statuses.map<Widget>(((String, String) s) => ChoiceChip(
                                      label: Text(s.$2),
                                      selected: _statutController == s.$1,
                                      onSelected: (_) => setState(() => _statutController = s.$1),
                                    )).toList(),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                controller: _chapitresController,
                                decoration: InputDecoration(
                                  labelText: l10n.detailChaptersRead,
                                  prefixIcon: const Icon(Icons.menu_book_outlined),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(l10n.detailRating, style: const TextStyle(fontWeight: FontWeight.w500)),
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
                                  title: Text(l10n.detailType),
                                  trailing: Text(_typeController, style: const TextStyle(color: Colors.grey)),
                                ),
                                const Divider(height: 1, indent: 56),
                                ListTile(
                                  leading: const Icon(Icons.bookmark_outline),
                                  title: Text(l10n.detailStatus),
                                  trailing: Text(statusLabel(_statutController, l10n), style: const TextStyle(color: Colors.grey)),
                                ),
                                const Divider(height: 1, indent: 56),
                                ListTile(
                                  leading: const Icon(Icons.menu_book_outlined),
                                  title: Text(l10n.detailChaptersRead),
                                  trailing: Text(_chapitresController.text, style: const TextStyle(color: Colors.grey)),
                                ),
                                const Divider(height: 1, indent: 56),
                                ListTile(
                                  leading: const Icon(Icons.star_outline),
                                  title: Text(l10n.detailRating),
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

                    _SectionLabel(l10n.detailLinks),
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
                                label: Text(l10n.detailAddLink),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(child: Text(l10n.detailNoLink)),
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
                      _SectionLabel(l10n.detailSyncSection),
                      Card(
                        margin: EdgeInsets.zero,
                        child: Consumer(
                          builder: (context, ref, _) {
                            final prefs = ref.watch(syncPrefsProvider);
                            return Column(
                              children: [
                                ListTile(
                                  leading: Icon(
                                    _anilistId != null ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
                                    color: _anilistId != null ? AppColors.success : Colors.grey,
                                  ),
                                  title: Text(_anilistId != null
                                      ? l10n.detailLinked(_anilistId!)
                                      : l10n.detailNotLinked),
                                  subtitle: Text(_lastSyncedAt != null
                                      ? l10n.detailLastSync(_formatDate(_lastSyncedAt!))
                                      : l10n.detailNeverSynced),
                                  trailing: TextButton(
                                    onPressed: _anilistId != null ? _delier : _lier,
                                    child: Text(_anilistId != null ? l10n.detailUnlink : l10n.detailLink),
                                  ),
                                ),
                                if (_anilistId != null)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: FilledButton.tonalIcon(
                                        onPressed: _syncEnCours || !prefs.maitre ? null : _synchroniserMaintenant,
                                        icon: _syncEnCours
                                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                            : const Icon(Icons.sync, size: 18),
                                        label: Text(_syncEnCours ? l10n.detailSyncing : l10n.detailSyncNow),
                                      ),
                                    ),
                                  ),
                                const Divider(height: 1, indent: 56),
                                _SyncToggleFiche(
                                  label: l10n.detailSyncCover,
                                  value: _syncImage,
                                  globalActif: prefs.maitre && prefs.image,
                                  note: _imageSource == 'utilisateur' ? l10n.detailSyncCoverCustom : null,
                                  onChanged: (v) {
                                    setState(() => _syncImage = v);
                                    _setToggleSync(MangaTableCompanion(syncImage: Value(v)));
                                  },
                                ),
                                _SyncToggleFiche(
                                  label: l10n.detailSyncDescription,
                                  value: _syncDescription,
                                  globalActif: prefs.maitre && prefs.description,
                                  onChanged: (v) {
                                    setState(() => _syncDescription = v);
                                    _setToggleSync(MangaTableCompanion(syncDescription: Value(v)));
                                  },
                                ),
                                _SyncToggleFiche(
                                  label: l10n.detailSyncGenres,
                                  value: _syncGenres,
                                  globalActif: prefs.maitre && prefs.genres,
                                  onChanged: (v) {
                                    setState(() => _syncGenres = v);
                                    _setToggleSync(MangaTableCompanion(syncGenres: Value(v)));
                                  },
                                ),
                                _SyncToggleFiche(
                                  label: l10n.detailSyncType,
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
    final l10n = AppLocalizations.of(context)!;
    final sousTitre = !globalActif ? l10n.detailSyncGlobalOff : note;
    return SwitchListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      subtitle: sousTitre == null ? null : Text(sousTitre, style: const TextStyle(fontSize: 11)),
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
