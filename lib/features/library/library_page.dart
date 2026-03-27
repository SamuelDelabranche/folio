import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/features/add_Manga/add_manga_page.dart';
import 'package:folio/features/manga_detail/manga_detail_page.dart';
import 'package:folio/shared/widgets/manga_card.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangas = ref.watch(mangasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Folio')),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AddMangaPage()));
      },
      child: const Icon(Icons.add),),

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
          itemBuilder: (context, index){
            return InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MangaDetailPage(mangaData: liste[index]),)),
              child: MangaCard(mangaData: liste[index])
            );
          }
        ),
        ), 
    );
  }
}
