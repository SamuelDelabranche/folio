import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/features/add_Manga/add_manga_page.dart';
import 'package:folio/features/manga_detail/manga_detail_page.dart';
import 'package:folio/app/transitions.dart';
import 'package:folio/shared/widgets/manga_card.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPage();
}

class _LibraryPage extends ConsumerState<LibraryPage> {
  bool _modeSelection = false;
  List<MangaTableData> _mangaSelectionne = [];
  final _rechercheController = TextEditingController();
  String _recherche = '';

  @override
  void dispose() {
    _rechercheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mangas = ref.watch(mangasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma bibliothèque'),
        actions: [
          if (_modeSelection)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _mangaSelectionne.clear();
                  _modeSelection = false;
                });
              },
              icon: const Icon(Icons.close),
              label: const Text('Annuler'),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_modeSelection ? 96 : 56),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: TextField(
                  controller: _rechercheController,
                  onChanged: (value) => setState(() => _recherche = value.toLowerCase()),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un manga...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    suffixIcon: _recherche.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey.shade400),
                            onPressed: () {
                              _rechercheController.clear();
                              setState(() => _recherche = '');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),
                ),
              ),
              if (_modeSelection)
                Container(
                  color: AppColors.danger.withOpacity(0.1),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: AppColors.danger),
                      const SizedBox(width: 8),
                      Text(
                        '${_mangaSelectionne.length} sélectionné(s)',
                        style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_modeSelection) {
            final nav = Navigator.of(context);
            final messenger = ScaffoldMessenger.of(context);
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                icon: Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 48),
                title: Text('Attention !', style: TextStyle(color: AppColors.danger)),
                content: const Text(
                  'Cette action est irréversible.\nLes mangas seront définitivement supprimés.',
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
                      final dao = ref.read(mangaDaoProvider);
                      for (final manga in _mangaSelectionne) {
                        await dao.deleteManga(manga.id);
                      }
                      ref.invalidate(mangasProvider);
                      setState(() {
                        _mangaSelectionne.clear();
                        _modeSelection = false;
                      });
                      messenger.showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.success,
                          content: const Text(
                            'Manga(s) supprimé(s)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      );
                      nav.pop();
                    },
                    child: const Text('Supprimer'),
                  ),
                ],
              ),
            );
          } else {
            Navigator.push(context, fadeScaleRoute(AddMangaPage()));
          }
        },
        child: Icon(_modeSelection ? Icons.delete : Icons.add),
      ),

      body: mangas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur: $e')),
        data: (liste) {
          final listeFiltree = _recherche.isEmpty
              ? liste
              : liste.where((m) => m.titre.toLowerCase().contains(_recherche)).toList();

          if (liste.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_stories_outlined, size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Votre bibliothèque est vide',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appuyez sur + pour ajouter un manga',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (listeFiltree.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Aucun manga trouvé',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: listeFiltree.length,
                    itemBuilder: (context, index) {
                      final manga = listeFiltree[index];
                      final isSelected = _mangaSelectionne.contains(manga);
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onLongPress: () {
                          setState(() {
                            _modeSelection = true;
                            _mangaSelectionne.add(manga);
                          });
                        },
                        onTap: () {
                          if (!_modeSelection) {
                            Navigator.push(
                              context,
                              fadeScaleRoute(MangaDetailPage(mangaData: manga)),
                            );
                          } else {
                            setState(() {
                              if (isSelected) {
                                _mangaSelectionne.remove(manga);
                                if (_mangaSelectionne.isEmpty) _modeSelection = false;
                              } else {
                                _mangaSelectionne.add(manga);
                              }
                            });
                          }
                        },
                        child: Stack(
                          children: [
                            MangaCard(mangaData: manga),
                            if (isSelected)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.check_circle, color: Colors.white, size: 36),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
