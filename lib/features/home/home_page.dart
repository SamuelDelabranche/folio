import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/features/library/library_page.dart';
import 'package:folio/features/settings/settings_page.dart';
import 'package:folio/features/statistics/statistics_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePage();
}

class _HomePage extends ConsumerState<HomePage> {
  int _indexActif = 0;
  final List<Widget> _pages = [LibraryPage(), StatisticsPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_indexActif],
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
