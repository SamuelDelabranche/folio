import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: ref.watch(mangasProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        data: (mangas) {
          final totalMangas = mangas.length;
          final moyenneNote = mangas.isEmpty
              ? 0.0
              : mangas.map((m) => m.note).reduce((a, b) => a + b) / mangas.length;
          final totalChapitres = mangas.isEmpty
              ? 0.0
              : mangas.map((m) => m.chapitres).reduce((a, b) => a + b);

          final termine = mangas.where((m) => m.status == 'Terminé').length;
          final enCours = mangas.where((m) => m.status == 'En cours').length;
          final aLire = mangas.where((m) => m.status == 'À lire').length;
          final abandonne = mangas.where((m) => m.status == 'Abandonné').length;

          final manga = mangas.where((m) => m.typeManga == 'Manga').length;
          final manhwa = mangas.where((m) => m.typeManga == 'Manhwa').length;
          final manhua = mangas.where((m) => m.typeManga == 'Manhua').length;
          final novel = mangas.where((m) => m.typeManga == 'Novel').length;

          final Map<String, int> genreCount = {};
          for (final m in mangas) {
            if (m.genre == null || m.genre!.isEmpty) continue;
            for (final genre in m.genre!.split(',')) {
              genreCount[genre] = (genreCount[genre] ?? 0) + 1;
            }
          }
          final top5 = (genreCount.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .take(5)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Vue d'ensemble ──
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          _OverviewStat(
                            value: '$totalMangas',
                            label: 'Mangas',
                            icon: Icons.auto_stories_outlined,
                            color: Colors.deepPurple,
                          ),
                          const VerticalDivider(thickness: 1, width: 32),
                          _OverviewStat(
                            value: moyenneNote.toStringAsFixed(1),
                            label: 'Note moy.',
                            icon: Icons.star_outline,
                            color: Colors.amber,
                          ),
                          const VerticalDivider(thickness: 1, width: 32),
                          _OverviewStat(
                            value: '${totalChapitres.toInt()}',
                            label: 'Chapitres',
                            icon: Icons.menu_book_outlined,
                            color: Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Par statut ──
                _SectionCard(
                  title: 'Par statut',
                  child: Column(
                    children: [
                      _ProgressRow(label: 'Terminé', count: termine, total: totalMangas, color: Colors.green),
                      _ProgressRow(label: 'En cours', count: enCours, total: totalMangas, color: Colors.blue),
                      _ProgressRow(label: 'À lire', count: aLire, total: totalMangas, color: Colors.orange),
                      _ProgressRow(label: 'Abandonné', count: abandonne, total: totalMangas, color: Colors.red, last: true),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Par type ──
                _SectionCard(
                  title: 'Par type',
                  child: Column(
                    children: [
                      _ProgressRow(label: 'Manga', count: manga, total: totalMangas, color: Colors.deepPurple),
                      _ProgressRow(label: 'Manhwa', count: manhwa, total: totalMangas, color: Colors.indigo),
                      _ProgressRow(label: 'Manhua', count: manhua, total: totalMangas, color: Colors.cyan),
                      _ProgressRow(label: 'Novel', count: novel, total: totalMangas, color: Colors.brown, last: true),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Top genres ──
                _SectionCard(
                  title: 'Top genres',
                  child: top5.isEmpty
                      ? const Text('Aucun genre renseigné')
                      : Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: top5
                              .map(
                                (e) => Chip(
                                  label: Text('${e.key}  ${e.value}'),
                                  avatar: const Icon(Icons.tag, size: 14),
                                ),
                              )
                              .toList(),
                        ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Stat vue d'ensemble ──
class _OverviewStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _OverviewStat({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ── Card de section ──
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

// ── Ligne barre de progression ──
class _ProgressRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;
  final bool last;

  const _ProgressRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : count / total;
    final percentLabel = (percent * 100).toInt();

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label)),
            Text(
              '$count  ·  $percentLabel%',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 6,
            backgroundColor: color.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (!last) const SizedBox(height: 14),
      ],
    );
  }
}
