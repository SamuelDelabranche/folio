import 'package:flutter/material.dart';
import 'package:folio/features/library/mock_data.dart';
import 'package:folio/shared/widgets/manga_card.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Folio'),
          ),

          body: Center(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                ),
              itemCount: mockMangas.length,
              itemBuilder: (context, index) {
                return MangaCard(manga: mockMangas[index]);
              },
            )
          ),
    );
  }

}