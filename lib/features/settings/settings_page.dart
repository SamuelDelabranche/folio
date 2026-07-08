import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/constants.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/data/database/daos/manga_dao.dart';
import 'package:folio/features/onboarding/onboarding_page.dart';
import 'package:folio/generated/app_localizations.dart';
import 'package:folio/services/anilist/sync_engine.dart';
import 'package:folio/services/cover_service.dart';
import 'package:folio/services/transfer_service.dart';
import 'package:folio/services/update_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final mangas = await _dao.getAllMangas();

      if (mangas.isEmpty) {
        messenger.showSnackBar(SnackBar(
          backgroundColor: AppColors.info,
          content: Text(l10n.settingsExportEmpty, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
        ));
        return;
      }

      final json = exporterEnJson(
        mangas,
        ref.read(customGenresProvider),
        ref.read(customTypesProvider),
      );

      final dossier = await getTemporaryDirectory();
      final fichier = File('${dossier.path}/folio_export.json');
      await fichier.writeAsString(json);
      await SharePlus.instance.share(ShareParams(files: [XFile(fichier.path)]));
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.danger,
        content: Text(l10n.settingsExportError, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
      ));
    }
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, ThemeMode current) {
    final l10n = AppLocalizations.of(context)!;
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
            Text(l10n.settingsThemeTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _ThemeOption(
              icon: Icons.light_mode_outlined,
              label: l10n.settingsThemeLight,
              selected: current == ThemeMode.light,
              onTap: () { ref.read(themeModeProvider.notifier).set(ThemeMode.light); Navigator.pop(context); },
            ),
            const SizedBox(height: 8),
            _ThemeOption(
              icon: Icons.brightness_auto_outlined,
              label: l10n.settingsThemeAuto,
              selected: current == ThemeMode.system,
              onTap: () { ref.read(themeModeProvider.notifier).set(ThemeMode.system); Navigator.pop(context); },
            ),
            const SizedBox(height: 8),
            _ThemeOption(
              icon: Icons.dark_mode_outlined,
              label: l10n.settingsThemeDark,
              selected: current == ThemeMode.dark,
              onTap: () { ref.read(themeModeProvider.notifier).set(ThemeMode.dark); Navigator.pop(context); },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          final locale = ref.read(localeProvider);
          return Padding(
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
                Text(l10n.settingsLanguageTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _ThemeOption(
                  icon: Icons.language,
                  label: '🇫🇷  ${l10n.settingsLanguageFr}',
                  selected: locale.languageCode == 'fr',
                  onTap: () {
                    ref.read(localeProvider.notifier).set(const Locale('fr'));
                    Navigator.pop(sheetCtx);
                  },
                ),
                const SizedBox(height: 8),
                _ThemeOption(
                  icon: Icons.language,
                  label: '🇬🇧  ${l10n.settingsLanguageEn}',
                  selected: locale.languageCode == 'en',
                  onTap: () {
                    ref.read(localeProvider.notifier).set(const Locale('en'));
                    Navigator.pop(sheetCtx);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showStartTabPicker(int current) {
    final l10n = AppLocalizations.of(context)!;
    final tabs = [
      (0, Icons.auto_stories_outlined, l10n.navLibrary),
      (1, Icons.analytics_outlined, l10n.navStatistics),
      (2, Icons.settings_outlined, l10n.navSettings),
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
            Text(l10n.settingsStartTabTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  void _montrerDisclaimerContenu() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.shield_outlined, color: Theme.of(context).colorScheme.primary, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    l10n.copyrightTitle,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.copyrightBody,
                style: const TextStyle(height: 1.6, fontSize: 14),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final uri = Uri.parse('https://${l10n.copyrightContact}');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  l10n.copyrightContact,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(sheetCtx),
                  child: Text(l10n.commonClose),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _revoirIntro() async {
    await resetOnboarding();
    if (!mounted) return;
    unawaited(Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingPage())));
  }

  Future<void> _verifierMaj() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final info = await UpdateService.checkForUpdate(force: true);
      if (!mounted) return;
      if (info == null) {
        messenger.showSnackBar(SnackBar(
          backgroundColor: AppColors.success,
          content: Text(l10n.settingsUpToDate, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
        ));
      } else {
        messenger.showSnackBar(SnackBar(
          backgroundColor: AppColors.info,
          duration: const Duration(seconds: 6),
          content: Text(l10n.settingsUpdateAvailable(info.latestVersion), style: const TextStyle(color: Colors.black87)),
          action: SnackBarAction(
            label: l10n.settingsUpdateDownload,
            textColor: Colors.black87,
            onPressed: () => UpdateService.openReleasePage(info.releaseUrl),
          ),
        ));
      }
    } catch (_) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.danger,
        content: Text(AppLocalizations.of(context)!.settingsUpdateError, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.delete_forever_outlined, color: AppColors.danger, size: 48),
        title: Text(l10n.commonWarning, style: TextStyle(color: AppColors.danger)),
        content: Text(l10n.settingsClearContent, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
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
                content: Text(l10n.settingsClearSuccess, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
              ));
            },
            child: Text(l10n.settingsClear),
          ),
        ],
      ),
    );
  }

  Future<void> _toutLier() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final mangas = await _dao.getAllMangas();
    final nonLies = mangas.where((m) => m.anilistId == null).length;
    if (!mounted) return;
    if (nonLies == 0) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.success,
        content: Text(l10n.settingsSyncAlreadyLinked, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
      ));
      return;
    }
    final secondes = (nonLies * 5).ceil();
    final estimation = secondes < 60 ? '$secondes s' : '${(secondes / 60).ceil()} min';
    unawaited(showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.add_link, size: 44),
        title: Text(l10n.settingsSyncLinkAll),
        content: Text(
          l10n.settingsSyncLinkDialog(nonLies, estimation),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(syncEngineProvider).lierTout();
            },
            child: Text(l10n.settingsSyncLaunch),
          ),
        ],
      ),
    ));
  }

  Future<void> _toutSynchroniser() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final mangas = await _dao.getAllMangas();
    final total = mangas.length;
    if (!mounted) return;
    if (total == 0) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: AppColors.info,
        content: Text(l10n.settingsSyncLibraryEmpty, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
      ));
      return;
    }
    final secondes = (total * 5).ceil();
    final estimation = secondes < 60 ? '$secondes s' : '${(secondes / 60).ceil()} min';
    unawaited(showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.sync, size: 44),
        title: Text(l10n.settingsSyncAll),
        content: Text(
          l10n.settingsSyncAllDialog(total, estimation),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(syncEngineProvider).toutSynchroniser();
            },
            child: Text(l10n.settingsSyncLaunch),
          ),
        ],
      ),
    ));
  }

  void _importer() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        icon: Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 48),
        title: Text(l10n.commonWarning, style: TextStyle(color: AppColors.danger)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.settingsImportWarning, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              l10n.settingsImportWarningTags,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(dialogContext);
              try {
                final result = await FilePicker.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['json'],
                );
                if (result == null) return;

                final fichier = File(result.files.single.path!);
                if (await fichier.length() > 10 * 1024 * 1024) {
                  throw const FormatException('Fichier trop volumineux');
                }
                final contenu = await fichier.readAsString();
                final import = importerDepuisJson(contenu);

                await _dao.replaceAllMangas(import.mangas);

                for (final g in import.customGenres) {
                  await ref.read(customGenresProvider.notifier).add(g);
                }
                for (final t in import.customTypes) {
                  await ref.read(customTypesProvider.notifier).add(t);
                }

                messenger.showSnackBar(SnackBar(
                  backgroundColor: AppColors.success,
                  content: Text(l10n.settingsImportSuccess(import.mangas.length), textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87)),
                ));
              } catch (e) {
                messenger.showSnackBar(SnackBar(
                  backgroundColor: AppColors.danger,
                  content: Text(l10n.settingsImportError, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                ));
              }
            },
            child: Text(l10n.settingsImportContinue),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _SectionLabel(l10n.settingsSectionGeneral),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final tab = ref.watch(startTabProvider);
                      final label = switch (tab) {
                        1 => l10n.navStatistics,
                        2 => l10n.navSettings,
                        _ => l10n.navLibrary,
                      };
                      return _SettingsTile(
                        icon: Icons.home_outlined,
                        iconColor: AppColors.primary,
                        title: l10n.settingsStartTab,
                        trailing: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        onTap: () => _showStartTabPicker(tab),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 68),
                  Consumer(
                    builder: (context, ref, _) {
                      final locale = ref.watch(localeProvider);
                      final label = locale.languageCode == 'en'
                          ? l10n.settingsLanguageEn
                          : l10n.settingsLanguageFr;
                      return _SettingsTile(
                        icon: Icons.language_outlined,
                        iconColor: Colors.indigo,
                        title: l10n.settingsLanguage,
                        trailing: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        onTap: _showLanguagePicker,
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 68),
                  _SettingsTile(
                    icon: Icons.replay_outlined,
                    iconColor: Colors.teal,
                    title: l10n.settingsReplayIntro,
                    subtitle: l10n.settingsReplayIntroSub,
                    onTap: _revoirIntro,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionLabel(l10n.settingsSectionData),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.upload_outlined,
                    iconColor: Colors.blue,
                    title: l10n.settingsExport,
                    subtitle: l10n.settingsExportSub,
                    onTap: _exporter,
                  ),
                  const Divider(height: 1, indent: 68),
                  _SettingsTile(
                    icon: Icons.download_outlined,
                    iconColor: Colors.green,
                    title: l10n.settingsImport,
                    subtitle: l10n.settingsImportSub,
                    onTap: _importer,
                  ),
                  const Divider(height: 1, indent: 68),
                  _SettingsTile(
                    icon: Icons.delete_forever_outlined,
                    iconColor: AppColors.danger,
                    title: l10n.settingsClear,
                    subtitle: l10n.settingsClearSub,
                    onTap: _toutEffacer,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionLabel(l10n.settingsSectionSync),
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
                        title: Text(l10n.settingsSyncAnilist),
                        subtitle: Text(l10n.settingsSyncAnilistSub),
                        value: sync.maitre,
                        onChanged: (v) {
                          notifier.setMaitre(v);
                          if (!v) ref.read(syncEngineProvider).annuler();
                        },
                      ),
                      const Divider(height: 1, indent: 68),
                      _SyncFieldSwitch(
                        label: l10n.settingsSyncCovers,
                        value: sync.image,
                        enabled: sync.maitre,
                        onChanged: notifier.setImage,
                      ),
                      _SyncFieldSwitch(
                        label: l10n.settingsSyncDescriptions,
                        value: sync.description,
                        enabled: sync.maitre,
                        onChanged: notifier.setDescription,
                      ),
                      _SyncFieldSwitch(
                        label: l10n.settingsSyncGenres,
                        value: sync.genres,
                        enabled: sync.maitre,
                        onChanged: notifier.setGenres,
                      ),
                      _SyncFieldSwitch(
                        label: l10n.settingsSyncTypes,
                        value: sync.type,
                        enabled: sync.maitre,
                        onChanged: notifier.setType,
                      ),
                      const Divider(height: 1, indent: 68),
                      Consumer(
                        builder: (context, ref, _) {
                          final enCours = ref.watch(syncEnCoursProvider);
                          if (enCours) {
                            return _SettingsTile(
                              icon: Icons.stop_circle_outlined,
                              iconColor: AppColors.danger,
                              title: l10n.settingsSyncStop,
                              subtitle: l10n.settingsSyncStopSub,
                              onTap: () => ref.read(syncEngineProvider).annuler(),
                            );
                          }
                          return Column(
                            children: [
                              _SettingsTile(
                                icon: Icons.add_link,
                                iconColor: AppColors.accent,
                                title: l10n.settingsSyncLinkAll,
                                subtitle: l10n.settingsSyncLinkAllSub,
                                onTap: sync.maitre ? _toutLier : null,
                              ),
                              const Divider(height: 1, indent: 68),
                              _SettingsTile(
                                icon: Icons.sync,
                                iconColor: AppColors.primary,
                                title: l10n.settingsSyncAll,
                                subtitle: l10n.settingsSyncAllSub,
                                onTap: sync.maitre ? _toutSynchroniser : null,
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.settingsSyncNote,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            _SectionLabel(l10n.settingsSectionAppearance),
            Card(
              margin: EdgeInsets.zero,
              child: Consumer(
                builder: (context, ref, _) {
                  final mode = ref.watch(themeModeProvider);
                  final label = switch (mode) {
                    ThemeMode.light => l10n.settingsThemeLight,
                    ThemeMode.dark => l10n.settingsThemeDark,
                    ThemeMode.system => l10n.settingsThemeAuto,
                  };
                  return _SettingsTile(
                    icon: Icons.palette_outlined,
                    iconColor: Colors.purple,
                    title: l10n.settingsTheme,
                    trailing: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    onTap: () => _showThemePicker(context, ref, mode),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            _SectionLabel(l10n.settingsSectionAbout),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  if (!estBuildPlayStore) ...[
                    _SettingsTile(
                      icon: Icons.system_update_alt_outlined,
                      iconColor: AppColors.accent,
                      title: l10n.settingsCheckUpdate,
                      subtitle: l10n.settingsCheckUpdateSub,
                      onTap: _verifierMaj,
                    ),
                    const Divider(height: 1, indent: 68),
                  ],
                  _SettingsTile(
                    icon: Icons.shield_outlined,
                    iconColor: Colors.green.shade700,
                    title: l10n.settingsCopyright,
                    subtitle: l10n.settingsCopyrightSub,
                    onTap: _montrerDisclaimerContenu,
                  ),
                  const Divider(height: 1, indent: 68),
                  _SettingsTile(
                    icon: Icons.code_outlined,
                    iconColor: Colors.blueGrey,
                    title: l10n.settingsSourceCode,
                    subtitle: l10n.settingsSourceCodeSub,
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
