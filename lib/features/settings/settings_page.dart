import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/data/database/daos/manga_dao.dart';
import 'package:folio/data/models/lien.dart';
import 'package:folio/features/onboarding/onboarding_page.dart';
import 'package:folio/services/anilist/sync_engine.dart';
import 'package:folio/services/cover_service.dart';
import 'package:folio/services/update_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
    final messenger = ScaffoldMessenger.of(context);
    try {
      final mangas = await _dao.getAllMangas();

      if (mangas.isEmpty) {
        messenger.showSnackBar(SnackBar(
          backgroundColor: AppColors.info,
          content: const Text('Aucun manga à exporter', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87)),
        ));
        return;
      }

      final prepJson = mangas.map((manga) => {
        'titre': manga.titre,
        'description': manga.description,
        'imagePath': manga.imagePath,
        'status': manga.status,
        'genre': manga.genre,
        'typeManga': manga.typeManga,
        'estFavori': manga.estFavori,
        'note': manga.note,
        'chapitres': manga.chapitres,
        'liens': manga.liens,
        'anilistId': manga.anilistId,
        'lastSyncedAt': manga.lastSyncedAt?.toIso8601String(),
        'syncImage': manga.syncImage,
        'syncDescription': manga.syncDescription,
        'syncGenres': manga.syncGenres,
        'syncType': manga.syncType,
        'imageSource': manga.imageSource,
      }).toList();

      final dossier = await getTemporaryDirectory();
      final fichier = File('${dossier.path}/folio_export.json');
      await fichier.writeAsString(jsonEncode(prepJson));
      await SharePlus.instance.share(ShareParams(files: [XFile(fichier.path)]));
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.danger,
        content: const Text("Erreur lors de l'export", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      ));
    }
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, ThemeMode current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Apparence', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _ThemeOption(
              icon: Icons.light_mode_outlined,
              label: 'Clair',
              selected: current == ThemeMode.light,
              onTap: () { ref.read(themeModeProvider.notifier).set(ThemeMode.light); Navigator.pop(context); },
            ),
            const SizedBox(height: 8),
            _ThemeOption(
              icon: Icons.brightness_auto_outlined,
              label: 'Automatique',
              selected: current == ThemeMode.system,
              onTap: () { ref.read(themeModeProvider.notifier).set(ThemeMode.system); Navigator.pop(context); },
            ),
            const SizedBox(height: 8),
            _ThemeOption(
              icon: Icons.dark_mode_outlined,
              label: 'Sombre',
              selected: current == ThemeMode.dark,
              onTap: () { ref.read(themeModeProvider.notifier).set(ThemeMode.dark); Navigator.pop(context); },
            ),
          ],
        ),
      ),
    );
  }

  void _showStartTabPicker(int current) {
    const tabs = [
      (0, Icons.auto_stories_outlined, 'Bibliothèque'),
      (1, Icons.analytics_outlined, 'Statistiques'),
      (2, Icons.settings_outlined, 'Paramètres'),
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Onglet de démarrage', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            for (final (index, icone, label) in tabs) ...[
              _ThemeOption(
                icon: icone,
                label: label,
                selected: current == index,
                onTap: () {
                  ref.read(startTabProvider.notifier).set(index);
                  Navigator.pop(context);
                },
              ),
              if (index < 2) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _revoirIntro() async {
    await resetOnboarding();
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingPage()));
  }

  Future<void> _verifierMaj() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final info = await UpdateService.checkForUpdate(force: true);
      if (!mounted) return;
      if (info == null) {
        messenger.showSnackBar(SnackBar(
          backgroundColor: AppColors.success,
          content: const Text('Folio est à jour', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87)),
        ));
      } else {
        messenger.showSnackBar(SnackBar(
          backgroundColor: AppColors.info,
          duration: const Duration(seconds: 6),
          content: Text('Version ${info.latestVersion} disponible', style: const TextStyle(color: Colors.black87)),
          action: SnackBarAction(
            label: 'Télécharger',
            textColor: Colors.black87,
            onPressed: () => UpdateService.openReleasePage(info.releaseUrl),
          ),
        ));
      }
    } catch (_) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.danger,
        content: const Text('Vérification impossible (hors ligne ?)', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      ));
    }
  }

  Future<void> _ouvrirCodeSource() async {
    final uri = Uri.parse('https://github.com/SamuelDelabranche/folio');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _toutEffacer() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.delete_forever_outlined, color: AppColors.danger, size: 48),
        title: Text('Tout effacer ?', style: TextStyle(color: AppColors.danger)),
        content: const Text(
          'Toute votre bibliothèque sera définitivement supprimée.\n\nPensez à exporter vos données avant !',
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
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(dialogContext);
              await _dao.deleteAllMangas();
              await CoverService.toutSupprimer();
              messenger.showSnackBar(SnackBar(
                backgroundColor: AppColors.success,
                content: const Text('Bibliothèque effacée', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87)),
              ));
            },
            child: const Text('Tout effacer'),
          ),
        ],
      ),
    );
  }

  Future<void> _toutLier() async {
    final messenger = ScaffoldMessenger.of(context);
    final mangas = await _dao.getAllMangas();
    final nonLies = mangas.where((m) => m.anilistId == null).length;
    if (!mounted) return;
    if (nonLies == 0) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.success,
        content: const Text('Tous les mangas sont déjà liés', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87)),
      ));
      return;
    }
    final secondes = (nonLies * 5).ceil();
    final estimation = secondes < 60 ? '$secondes s' : '${(secondes / 60).ceil()} min';
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.add_link, size: 44),
        title: const Text('Tout lier ?'),
        content: Text(
          '$nonLies manga(s) non lié(s) — environ $estimation.\n\nChaque manga sera lié à la fiche AniList correspondant le mieux à son titre, puis synchronisé. Tu pourras corriger une liaison depuis la fiche (mode édition).',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(syncEngineProvider).lierTout();
            },
            child: const Text('Lancer'),
          ),
        ],
      ),
    );
  }

  Future<void> _toutResynchroniser() async {
    final messenger = ScaffoldMessenger.of(context);
    final mangas = await _dao.getAllMangas();
    final lies = mangas.where((m) => m.anilistId != null).length;
    if (!mounted) return;
    if (lies == 0) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.info,
        content: const Text('Aucun manga lié à AniList', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87)),
      ));
      return;
    }
    final secondes = (lies * 2.5).ceil();
    final estimation = secondes < 60 ? '$secondes s' : '${(secondes / 60).ceil()} min';
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.sync, size: 44),
        title: const Text('Tout resynchroniser ?'),
        content: Text(
          '$lies manga(s) lié(s) — environ $estimation.\n\nLa synchronisation tournera en arrière-plan, tu peux continuer à utiliser l\'application.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(syncEngineProvider).runAll(force: true);
            },
            child: const Text('Lancer'),
          ),
        ],
      ),
    );
  }

  MangaTableCompanion _companionDepuisJson(dynamic item) {
    if (item is! Map<String, dynamic>) {
      throw const FormatException('Item invalide');
    }
    final titre = item['titre'];
    if (titre is! String || titre.trim().isEmpty) {
      throw const FormatException('Titre manquant');
    }
    final note = ((item['note'] as num?)?.toDouble() ?? 0).clamp(0.0, 10.0);
    final chapitres = ((item['chapitres'] as num?)?.toDouble() ?? 0).clamp(0.0, double.maxFinite);

    String? liensJson = item['liens'] as String?;
    if (liensJson != null && liensJson.isNotEmpty) {
      final liens = liensFromJson(liensJson).where((l) => urlEstValide(l.url)).toList();
      liensJson = liensToJson(liens);
    }

    final anilistId = (item['anilistId'] as num?)?.toInt();
    final lastSyncedAt = item['lastSyncedAt'] is String
        ? DateTime.tryParse(item['lastSyncedAt'] as String)
        : null;

    String? imagePath = item['imagePath'] as String?;
    if (imagePath != null && !File(imagePath).existsSync()) {
      imagePath = null;
    }
    var imageSource = item['imageSource'] as String?;
    if (!const ['aucune', 'utilisateur', 'anilist'].contains(imageSource)) {
      imageSource = imagePath != null ? 'utilisateur' : 'aucune';
    }
    if (imagePath == null) imageSource = 'aucune';

    return MangaTableCompanion(
      titre: Value(titre.trim()),
      description: Value(item['description'] as String?),
      imagePath: Value(imagePath),
      status: Value(item['status'] as String? ?? 'À lire'),
      genre: Value(item['genre'] as String?),
      typeManga: Value(item['typeManga'] as String? ?? 'Manga'),
      estFavori: Value(item['estFavori'] as bool? ?? false),
      note: Value(note),
      chapitres: Value(chapitres),
      liens: Value(liensJson),
      anilistId: Value(anilistId),
      lastSyncedAt: Value(lastSyncedAt),
      syncImage: Value(item['syncImage'] as bool? ?? true),
      syncDescription: Value(item['syncDescription'] as bool? ?? true),
      syncGenres: Value(item['syncGenres'] as bool? ?? true),
      syncType: Value(item['syncType'] as bool? ?? true),
      imageSource: Value(imageSource!),
    );
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
              try {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['json'],
                );
                if (result == null) return;

                final fichier = File(result.files.single.path!);
                if (await fichier.length() > 10 * 1024 * 1024) {
                  throw const FormatException('Fichier trop volumineux');
                }
                final contenu = await fichier.readAsString();
                final List<dynamic> listeJson = jsonDecode(contenu);

                final companions =
                    listeJson.map((item) => _companionDepuisJson(item)).toList();

                await _dao.replaceAllMangas(companions);
                messenger.showSnackBar(SnackBar(
                  backgroundColor: AppColors.success,
                  content: Text('${companions.length} manga(s) importé(s)', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
                ));
              } catch (e) {
                messenger.showSnackBar(SnackBar(
                  backgroundColor: AppColors.danger,
                  content: const Text('Fichier invalide ou corrompu', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                ));
              }
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

            _SectionLabel('Général'),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final tab = ref.watch(startTabProvider);
                      final label = switch (tab) {
                        1 => 'Statistiques',
                        2 => 'Paramètres',
                        _ => 'Bibliothèque',
                      };
                      return _SettingsTile(
                        icon: Icons.home_outlined,
                        iconColor: AppColors.primary,
                        title: 'Onglet de démarrage',
                        trailing: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        onTap: () => _showStartTabPicker(tab),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 68),
                  _SettingsTile(
                    icon: Icons.replay_outlined,
                    iconColor: Colors.teal,
                    title: 'Revoir l\'introduction',
                    subtitle: 'Rejouer les écrans de bienvenue',
                    onTap: _revoirIntro,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

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
                  const Divider(height: 1, indent: 68),
                  _SettingsTile(
                    icon: Icons.delete_forever_outlined,
                    iconColor: AppColors.danger,
                    title: 'Tout effacer',
                    subtitle: 'Supprime définitivement la bibliothèque',
                    onTap: _toutEffacer,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionLabel('Synchronisation'),
            Card(
              margin: EdgeInsets.zero,
              child: Consumer(
                builder: (context, ref, _) {
                  final sync = ref.watch(syncPrefsProvider);
                  final notifier = ref.read(syncPrefsProvider.notifier);
                  return Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.sync_outlined),
                        title: const Text('Synchronisation AniList'),
                        subtitle: const Text('Enrichit les fiches liées en arrière-plan'),
                        value: sync.maitre,
                        onChanged: (v) {
                          notifier.setMaitre(v);
                          if (!v) ref.read(syncEngineProvider).annuler();
                        },
                      ),
                      const Divider(height: 1, indent: 68),
                      _SyncFieldSwitch(
                        label: 'Images de couverture',
                        value: sync.image,
                        enabled: sync.maitre,
                        onChanged: notifier.setImage,
                      ),
                      _SyncFieldSwitch(
                        label: 'Descriptions',
                        value: sync.description,
                        enabled: sync.maitre,
                        onChanged: notifier.setDescription,
                      ),
                      _SyncFieldSwitch(
                        label: 'Genres',
                        value: sync.genres,
                        enabled: sync.maitre,
                        onChanged: notifier.setGenres,
                      ),
                      _SyncFieldSwitch(
                        label: 'Types (Manga, Manhwa…)',
                        value: sync.type,
                        enabled: sync.maitre,
                        onChanged: notifier.setType,
                      ),
                      _SyncFieldSwitch(
                        label: 'Descriptions en français (MangaDex)',
                        value: sync.mangadex,
                        enabled: sync.maitre && sync.description,
                        onChanged: notifier.setMangadex,
                      ),
                      const Divider(height: 1, indent: 68),
                      Consumer(
                        builder: (context, ref, _) {
                          final enCours = ref.watch(syncEnCoursProvider);
                          if (enCours) {
                            return _SettingsTile(
                              icon: Icons.stop_circle_outlined,
                              iconColor: AppColors.danger,
                              title: 'Arrêter la synchronisation',
                              subtitle: 'Une synchronisation est en cours',
                              onTap: () => ref.read(syncEngineProvider).annuler(),
                            );
                          }
                          return Column(
                            children: [
                              _SettingsTile(
                                icon: Icons.add_link,
                                iconColor: AppColors.accent,
                                title: 'Tout lier',
                                subtitle: 'Lie automatiquement les mangas non liés',
                                onTap: sync.maitre ? _toutLier : null,
                              ),
                              const Divider(height: 1, indent: 68),
                              _SettingsTile(
                                icon: Icons.sync,
                                iconColor: AppColors.primary,
                                title: 'Tout resynchroniser',
                                subtitle: 'Met à jour tous les mangas liés maintenant',
                                onTap: sync.maitre ? _toutResynchroniser : null,
                              ),
                            ],
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Chaque manga peut aussi désactiver ces champs '
                            'individuellement dans sa fiche. Données fournies '
                            'par AniList et MangaDex.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            _SectionLabel('Apparence'),
            Card(
              margin: EdgeInsets.zero,
              child: Consumer(
                builder: (context, ref, _) {
                  final mode = ref.watch(themeModeProvider);
                  final label = switch (mode) {
                    ThemeMode.light => 'Clair',
                    ThemeMode.dark => 'Sombre',
                    ThemeMode.system => 'Automatique',
                  };
                  return _SettingsTile(
                    icon: Icons.palette_outlined,
                    iconColor: Colors.purple,
                    title: 'Thème',
                    trailing: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    onTap: () => _showThemePicker(context, ref, mode),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            _SectionLabel('À propos'),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.system_update_alt_outlined,
                    iconColor: AppColors.accent,
                    title: 'Vérifier les mises à jour',
                    subtitle: 'Rechercher une nouvelle version',
                    onTap: _verifierMaj,
                  ),
                  const Divider(height: 1, indent: 68),
                  _SettingsTile(
                    icon: Icons.code_outlined,
                    iconColor: Colors.blueGrey,
                    title: 'Code source',
                    subtitle: 'Folio est open source (GitHub)',
                    onTap: _ouvrirCodeSource,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version = snapshot.data?.version ?? '–';
                return Center(
                  child: Text(
                    'Folio v$version',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncFieldSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _SyncFieldSwitch({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 68, right: 16),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: enabled ? onChanged : null,
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

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected ? color.withValues(alpha: 0.12) : Colors.transparent,
          border: Border.all(
            color: selected ? color : Colors.grey.withValues(alpha: 0.2),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? color : Colors.grey, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? color : null,
              ),
            ),
            const Spacer(),
            if (selected)
              Icon(Icons.check_circle_rounded, color: color, size: 20),
          ],
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
