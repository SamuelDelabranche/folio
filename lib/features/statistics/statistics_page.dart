import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/constants.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/generated/app_localizations.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: ref.watch(mangasProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${l10n.commonWarning} $err')),
        data: (mangas) {
          final totalMangas = mangas.length;
          final mangasNotes = mangas.where((m) => m.note != null).toList();
          final moyenneNote = mangasNotes.isEmpty
              ? 0.0
              : mangasNotes.map((m) => m.note!).reduce((a, b) => a + b) /
                    mangasNotes.length;
          final totalChapitres = mangas.isEmpty
              ? 0.0
              : mangas.map((m) => m.chapitres).reduce((a, b) => a + b);

          final termine = mangas.where((m) => m.status == 'Terminé').length;
          final enCours = mangas.where((m) => m.status == 'En cours').length;
          final aLire = mangas.where((m) => m.status == 'À lire').length;
          final abandonne = mangas.where((m) => m.status == 'Abandonné').length;

          final typeCount = <String, int>{'Manga': 0, 'Manhwa': 0, 'Manhua': 0, 'Novel': 0};
          for (final m in mangas) {
            typeCount[m.typeManga] = (typeCount[m.typeManga] ?? 0) + 1;
          }
          final types = typeCount.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          const typeColors = [
            AppColors.primary,
            AppColors.accent,
            AppColors.statutALire,
            AppColors.statutEnCours,
            Colors.teal,
            Colors.deepOrange,
          ];

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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          _OverviewStat(
                            value: '$totalMangas',
                            label: l10n.statsMangas,
                            icon: Icons.auto_stories_outlined,
                            color: AppColors.primary,
                          ),
                          const VerticalDivider(thickness: 1, width: 32),
                          _OverviewStat(
                            value: moyenneNote.toStringAsFixed(1),
                            label: l10n.statsAvgRating,
                            icon: Icons.star_outline,
                            color: AppColors.stars,
                          ),
                          const VerticalDivider(thickness: 1, width: 32),
                          _OverviewStat(
                            value: '${totalChapitres.toInt()}',
                            label: l10n.statsChapters,
                            icon: Icons.menu_book_outlined,
                            color: Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    mangasNotes.isEmpty
                        ? l10n.statsNoRating
                        : l10n.statsGlobalRating(
                            moyenneNote.toStringAsFixed(1),
                            mangasNotes.length,
                          ),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 12),

                _SectionCard(
                  title: l10n.statsByStatus,
                  child: Column(
                    children: [
                      _ProgressRow(label: l10n.statusFinished, count: termine, total: totalMangas, color: AppColors.statutTermine),
                      _ProgressRow(label: l10n.statusReading, count: enCours, total: totalMangas, color: AppColors.statutEnCours),
                      _ProgressRow(label: l10n.statusToRead, count: aLire, total: totalMangas, color: AppColors.statutALire),
                      _ProgressRow(label: l10n.statusDropped, count: abandonne, total: totalMangas, color: AppColors.statutAbandonne, last: true),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                _SectionCard(
                  title: l10n.statsByRating,
                  child: Column(
                    children: [
                      _ProgressRow(label: l10n.statsRated, count: mangasNotes.length, total: totalMangas, color: AppColors.stars),
                      _ProgressRow(label: l10n.detailRatingNone, count: totalMangas - mangasNotes.length, total: totalMangas, color: AppColors.statutAbandonne, last: true),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                _SectionCard(
                  title: l10n.statsByType,
                  child: Column(
                    children: [
                      for (final (i, e) in types.indexed)
                        _ProgressRow(
                          label: e.key,
                          count: e.value,
                          total: totalMangas,
                          color: typeColors[i % typeColors.length],
                          last: i == types.length - 1,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                _SectionCard(
                  title: l10n.statsTopGenres,
                  child: top5.isEmpty
                      ? Text(l10n.statsNoGenre)
                      : Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: top5
                              .map((e) => Chip(
                                    label: Text('${genreLabel(e.key, l10n)}  ${e.value}'),
                                    avatar: const Icon(Icons.tag, size: 14),
                                  ))
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
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

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
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (!last) const SizedBox(height: 14),
      ],
    );
  }
}
