import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/features/add_Manga/add_manga_page.dart';
import 'package:folio/features/manga_detail/manga_detail_page.dart';
import 'package:folio/shared/widgets/manga_card.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPage();
}

class _LibraryPage extends ConsumerState<LibraryPage> {
  bool _modeSelection = false;
  List<MangaTableData> _mangaSelectionne = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mangas = ref.watch(mangasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Folio')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_modeSelection) {
            final nav = Navigator.of(context);
            final messenger = ScaffoldMessenger.of(context);
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                icon: Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.danger,
                  size: 48,
                ),
                title: Text(
                  'Attention !',
                  style: TextStyle(color: AppColors.danger),
                ),
                content: Text(
                  'Cette action est irréversible.\nLes mangas seront définitivement supprimés.',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text('Annuler'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.danger,
                    ),
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
                          content: Text(
                            'Manga(s) supprimé(s)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      );
                      nav.pop();
                    },
                    child: Text('Supprimer'),
                  ),
                ],
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddMangaPage()),
            );
          }
        },

        child: Icon(_modeSelection ? Icons.delete : Icons.add),
      ),

      body: mangas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Text('Error detected: $e'),
        data: (liste) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.85,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: liste.length,
          itemBuilder: (context, index) {
            return InkWell(
              onLongPress: () {
                setState(() {
                  _modeSelection = true;
                  _mangaSelectionne.add(liste[index]);
                });
              },
              onTap: () {
                if (_modeSelection == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MangaDetailPage(mangaData: liste[index]),
                    ),
                  );
                } else {
                  if (!_mangaSelectionne.contains(liste[index])) {
                    setState(() {
                      _mangaSelectionne.add(liste[index]);
                    });
                  } else {
                    setState(() {
                      _mangaSelectionne.remove(liste[index]);
                      if (_mangaSelectionne.isEmpty) {
                        _modeSelection = false;
                      }
                    });
                  }
                }
              },
              child: Stack(
                children: [
                  MangaCard(mangaData: liste[index]),
                  if (_mangaSelectionne.contains(liste[index]))
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: Center(
                          child: Icon(Icons.check_circle, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
