import 'package:flutter/material.dart';
import 'package:folio/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/constants.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/features/library/library_page.dart';
import 'package:folio/features/settings/settings_page.dart';
import 'package:folio/features/statistics/statistics_page.dart';
import 'package:folio/services/update_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePage();
}

class _HomePage extends ConsumerState<HomePage> {
  int _indexActif = 0;
  final List<Widget> _pages = [LibraryPage(), StatisticsPage(), SettingsPage()];

  @override
  void initState() {
    super.initState();
    _indexActif = ref.read(startTabProvider);
    if (!estBuildPlayStore) {
      UpdateService.checkForUpdate().then((info) {
        if (info != null && mounted) _showUpdateDialog(info);
      });
    }
  }

  void _showUpdateDialog(UpdateInfo info) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.system_update_alt_outlined, size: 44, color: Theme.of(ctx).colorScheme.primary),
        title: Text(l10n.updateDialogTitle),
        content: Text(
          l10n.updateDialogContent(info.latestVersion),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.updateDialogLater),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              UpdateService.openReleasePage(info.releaseUrl);
            },
            icon: const Icon(Icons.download_outlined),
            label: Text(l10n.updateDialogDownload),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey(_indexActif),
          child: _pages[_indexActif],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexActif,
        onDestinationSelected: (value) => setState(() => _indexActif = value),
        destinations: [
          NavigationDestination(
            selectedIcon: const Icon(Icons.auto_stories),
            icon: const Icon(Icons.auto_stories_outlined),
            label: l10n.navLibrary,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.analytics),
            icon: const Icon(Icons.analytics_outlined),
            label: l10n.navStatistics,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.settings),
            icon: const Icon(Icons.settings_outlined),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
