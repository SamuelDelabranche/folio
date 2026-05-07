import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: ref
          .watch(mangasProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Erreur: $err')),
            data: (mangas) {
              final totalMangas = mangas.length;
              final moyenneNote = mangas.isEmpty
                  ? 0.0
                  : mangas.map((m) => m.note).reduce((a, b) => a + b) /
                        mangas.length;
              final totalChapitres = mangas.isEmpty
                  ? 0.0
                  : mangas.map((m) => m.chapitres).reduce((a, b) => a + b);

              final enCours = mangas.where((m) => m.status == 'En cours').length;
              final termine = mangas.where((m) => m.status == 'Terminé').length;
              final aLire = mangas.where((m) => m.status == 'À lire').length;
              final abandonne = mangas.where((m) => m.status == 'Abandonné').length;

              final manga = mangas.where((m) => m.typeManga == 'Manga').length;
              final manhwa = mangas.where((m) => m.typeManga == 'Manhwa').length;
              final manhua = mangas.where((m) => m.typeManga == 'Manhua').length;
              final novel = mangas.where((m) => m.typeManga == 'Novel').length;

              // Compter les genres
              final Map<String, int> genreCount = {};
              for (final m in mangas) {
                if (m.genre == null || m.genre!.isEmpty) continue;
                for (final genre in m.genre!.split(',')) {
                  genreCount[genre] = (genreCount[genre] ?? 0) + 1;
                }
              }
              final topGenres = genreCount.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));
              final top5 = topGenres.take(5).toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vue d'ensemble",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text("Total de mangas : "),
                                Text(totalMangas.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Note moyenne : "),
                                Text('${moyenneNote.toStringAsFixed(1)}/10'),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Total chapitres : "),
                                Text(totalChapitres.toInt().toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Par statut",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('En cours'),
                                Text(
                                  '$enCours (${(enCours / totalMangas * 100).toInt()}%)',
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: totalMangas == 0
                                  ? 0
                                  : enCours / totalMangas,
                            ),
                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Terminé'),
                                Text(
                                  '$termine (${(termine / totalMangas * 100).toInt()}%)',
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: totalMangas == 0
                                  ? 0
                                  : termine / totalMangas,
                            ),
                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('À lire'),
                                Text(
                                  '$aLire (${(aLire / totalMangas * 100).toInt()}%)',
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: totalMangas == 0 ? 0 : aLire / totalMangas,
                            ),
                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Abandonné'),
                                Text(
                                  '$abandonne (${(abandonne / totalMangas * 100).toInt()}%)',
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: totalMangas == 0
                                  ? 0
                                  : abandonne / totalMangas,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Par type",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Manga'),
                                Text('$manga (${totalMangas == 0 ? 0 : (manga / totalMangas * 100).toInt()}%)'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: totalMangas == 0 ? 0 : manga / totalMangas,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Manhwa'),
                                Text('$manhwa (${totalMangas == 0 ? 0 : (manhwa / totalMangas * 100).toInt()}%)'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: totalMangas == 0 ? 0 : manhwa / totalMangas,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Manhua'),
                                Text('$manhua (${totalMangas == 0 ? 0 : (manhua / totalMangas * 100).toInt()}%)'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: totalMangas == 0 ? 0 : manhua / totalMangas,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Novel'),
                                Text('$novel (${totalMangas == 0 ? 0 : (novel / totalMangas * 100).toInt()}%)'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: totalMangas == 0 ? 0 : novel / totalMangas,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Top genres",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (top5.isEmpty)
                              Text('Aucun genre renseigné')
                            else
                              for (final entry in top5) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key),
                                    Text('${entry.value} manga${entry.value > 1 ? 's' : ''}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: totalMangas == 0 ? 0 : entry.value / totalMangas,
                                ),
                                const SizedBox(height: 12),
                              ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
