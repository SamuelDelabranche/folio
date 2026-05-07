import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/data/database/daos/manga_dao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:drift/drift.dart' hide Column;

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends ConsumerState<SettingsPage> {
  late MangaDao _dao;

  @override
  void initState() {
    super.initState();
    _dao = ref.read(mangaDaoProvider);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _exporter() async {
    List<MangaTableData> _mangas = await _dao.getAllMangas();

    List<Map<String, dynamic>> _prepJson = _mangas.map((manga) {
      return {
        'titre': manga.titre,
        'description': manga.description,
        'imagePath': manga.imagePath,
        'status': manga.status,
        'genre': manga.genre,
        'typeManga': manga.typeManga,
        'estFavori': manga.estFavori,
        'note': manga.note,
        'chapitres': manga.chapitres,
      };
    }).toList();

    final String jsonMangas = jsonEncode(_prepJson);

    final dossier = await getTemporaryDirectory();
    final fichier = File('${dossier.path}/folio_export.json');
    await fichier.writeAsString(jsonMangas);

    await SharePlus.instance.share(ShareParams(files: [XFile(fichier.path)]));
  }

  void _importer() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        icon: Icon(
          Icons.warning_amber_rounded,
          color: AppColors.danger,
          size: 48,
        ),
        title: Text('Attention !', style: TextStyle(color: AppColors.danger)),
        content: Text(
          'Cette action est irréversible.\nLes mangas déjà présents seront définitivement supprimés.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(dialogContext);

              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['json'],
              );

              if (result == null) return;

              final fichier = File(result.files.single.path!);
              final contenu = await fichier.readAsString();
              final List<dynamic> listeJson = jsonDecode(contenu);

              await _dao.deleteAllMangas();

              for (final item in listeJson) {
                await _dao.insertManga(
                  MangaTableCompanion(
                    titre: Value(item['titre'] as String),
                    description: Value(item['description'] as String?),
                    imagePath: Value(item['imagePath'] as String?),
                    status: Value(item['status'] as String),
                    genre: Value(item['genre'] as String?),
                    typeManga: Value(item['typeManga'] as String),
                    estFavori: Value(item['estFavori'] as bool),
                    note: Value((item['note'] as num).toDouble()),
                    chapitres: Value((item['chapitres'] as num).toDouble()),
                  ),
                );
              }

              ref.invalidate(mangasProvider);
              messenger.showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.success,
                  content: Text(
                    'Bibliothèque importée avec succès',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              );
            },
            child: Text('Continuer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Données ──
            _SectionLabel('Données'),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.upload_outlined,
                    iconColor: Colors.blue,
                    title: 'Exporter la bibliothèque',
                    subtitle: 'Partager un fichier JSON',
                    onTap: _exporter,
                  ),
                  const Divider(height: 1, indent: 68),
                  _SettingsTile(
                    icon: Icons.download_outlined,
                    iconColor: Colors.green,
                    title: 'Importer la bibliothèque',
                    subtitle: 'Remplace les données existantes',
                    onTap: _importer,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Apparence ──
            _SectionLabel('Apparence'),
            Card(
              margin: EdgeInsets.zero,
              child: _SettingsTile(
                icon: Icons.palette_outlined,
                iconColor: Colors.purple,
                title: 'Thème',
                trailing: const Text('Automatique', style: TextStyle(color: Colors.grey, fontSize: 13)),
                onTap: null,
              ),
            ),
          ],
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
      padding: const EdgeInsets.only(left: 4, bottom: 8),
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(fontSize: 12)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }
}
