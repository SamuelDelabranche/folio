import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    UpdateService.checkForUpdate().then((info) {
      if (info != null && mounted) _showUpdateDialog(info);
    });
  }

  void _showUpdateDialog(UpdateInfo info) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.system_update_alt_outlined, size: 44, color: Theme.of(ctx).colorScheme.primary),
        title: const Text('Mise à jour disponible'),
        content: Text(
          'La version ${info.latestVersion} est disponible.\n\n'
          'Télécharge le nouvel APK depuis GitHub et installe-le pour mettre à jour.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Plus tard'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              UpdateService.openReleasePage(info.releaseUrl);
            },
            icon: const Icon(Icons.download_outlined),
            label: const Text('Télécharger'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        onDestinationSelected: (value) {
          setState(() {
            _indexActif = value;
          });
        },
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.auto_stories),
            icon: Icon(Icons.auto_stories_outlined),
            label: "Bibliothèque",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.analytics),
            icon: Icon(Icons.analytics_outlined),
            label: "Statistiques",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: "Paramètres",
          ),
        ],
      ),
    );
  }
}
