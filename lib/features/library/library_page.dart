import 'package:flutter/material.dart';
import 'package:folio/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:folio/features/add_Manga/add_manga_page.dart';
import 'package:folio/features/manga_detail/manga_detail_page.dart';
import 'package:folio/app/transitions.dart';
import 'package:folio/services/anilist/sync_engine.dart';
import 'package:folio/services/cover_service.dart';
import 'package:folio/shared/widgets/manga_card.dart';
import 'package:folio/shared/widgets/manga_list_tile.dart';

enum TriOption { aucun, titreAZ, titreZA, meilleureNote, moinsNote, plusChapitres, moinsChapitres }

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPage();
}

class _LibraryPage extends ConsumerState<LibraryPage> {
  bool _modeSelection = false;
  final Set<int> _idsSelectionnes = {};
  final _rechercheController = TextEditingController();
  String _recherche = '';
  String? _filtreStatus;
  String? _filtreType;
  bool? _filtreFavori;
  RangeValues _filtreNote = const RangeValues(0, 10);
  RangeValues _filtreChapitres = const RangeValues(0, 1000);
  TriOption _tri = TriOption.aucun;

  int get _filtresActifs {
    int count = 0;
    if (_filtreStatus != null) count++;
    if (_filtreType != null) count++;
    if (_filtreFavori != null) count++;
    if (_filtreNote.start != 0 || _filtreNote.end != 10) count++;
    if (_filtreChapitres.start != 0 || _filtreChapitres.end != 1000) count++;
    if (_tri != TriOption.aucun) count++;
    return count;
  }

  @override
  void dispose() {
    _rechercheController.dispose();
    super.dispose();
  }

  void _showFiltres() {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final statuses = [
            ('À lire', l10n.statusToRead),
            ('En cours', l10n.statusReading),
            ('Terminé', l10n.statusFinished),
            ('Abandonné', l10n.statusDropped),
          ];
          return SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.6,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.libFilterTitle,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _filtreStatus = null;
                            _filtreType = null;
                            _filtreFavori = null;
                            _filtreNote = const RangeValues(0, 10);
                            _filtreChapitres = const RangeValues(0, 1000);
                            _tri = TriOption.aucun;
                          });
                          setModalState(() {});
                        },
                        child: Text(l10n.libFilterReset),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FiltreSection(
                          titre: l10n.libFilterSortBy,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _TriCycleChip(
                                baseLabel: l10n.libFilterAlpha,
                                option1: TriOption.titreAZ,
                                label1: '↓',
                                option2: TriOption.titreZA,
                                label2: '↑',
                                current: _tri,
                                onTap: (v) { setState(() => _tri = v); setModalState(() {}); },
                              ),
                              _TriCycleChip(
                                baseLabel: l10n.libFilterRating,
                                option1: TriOption.meilleureNote,
                                label1: '↓',
                                option2: TriOption.moinsNote,
                                label2: '↑',
                                current: _tri,
                                onTap: (v) { setState(() => _tri = v); setModalState(() {}); },
                              ),
                              _TriCycleChip(
                                baseLabel: l10n.libFilterChapters,
                                option1: TriOption.plusChapitres,
                                label1: '↓',
                                option2: TriOption.moinsChapitres,
                                label2: '↑',
                                current: _tri,
                                onTap: (v) { setState(() => _tri = v); setModalState(() {}); },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FiltreSection(
                          titre: l10n.libFilterStatus,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: statuses.map<Widget>(((String, String) s) {
                              return FilterChip(
                                label: Text(s.$2),
                                selected: _filtreStatus == s.$1,
                                onSelected: (v) {
                                  setState(() => _filtreStatus = v ? s.$1 : null);
                                  setModalState(() {});
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FiltreSection(
                          titre: l10n.libFilterType,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: ['Manga', 'Manhwa', 'Manhua', 'Novel'].map((t) {
                              return FilterChip(
                                label: Text(t),
                                selected: _filtreType == t,
                                onSelected: (v) {
                                  setState(() => _filtreType = v ? t : null);
                                  setModalState(() {});
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FiltreSection(
                          titre: l10n.libFilterFavorites,
                          child: FilterChip(
                            label: Text(l10n.libFilterFavoritesOnly),
                            avatar: Icon(
                              Icons.favorite,
                              size: 14,
                              color: _filtreFavori == true ? Colors.red : Colors.grey,
                            ),
                            selected: _filtreFavori == true,
                            onSelected: (v) {
                              setState(() => _filtreFavori = v ? true : null);
                              setModalState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FiltreSection(
                          titre: l10n.libFilterRating,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${_filtreNote.start.toInt()}', style: const TextStyle(fontSize: 12)),
                                  Text('${_filtreNote.end.toInt()}', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              RangeSlider(
                                values: _filtreNote,
                                min: 0,
                                max: 10,
                                divisions: 10,
                                labels: RangeLabels(
                                  _filtreNote.start.toInt().toString(),
                                  _filtreNote.end.toInt().toString(),
                                ),
                                onChanged: (v) {
                                  setState(() => _filtreNote = v);
                                  setModalState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FiltreSection(
                          titre: l10n.libFilterChaptersRead,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${_filtreChapitres.start.toInt()}', style: const TextStyle(fontSize: 12)),
                                  Text(_filtreChapitres.end >= 1000 ? l10n.libChaptersPlus : '${_filtreChapitres.end.toInt()}', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              RangeSlider(
                                values: _filtreChapitres,
                                min: 0,
                                max: 1000,
                                divisions: 100,
                                labels: RangeLabels(
                                  _filtreChapitres.start.toInt().toString(),
                                  _filtreChapitres.end >= 1000 ? l10n.libChaptersPlus : _filtreChapitres.end.toInt().toString(),
                                ),
                                onChanged: (v) {
                                  setState(() => _filtreChapitres = v);
                                  setModalState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).then((_) { if (mounted) FocusScope.of(context).unfocus(); });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mangas = ref.watch(mangasProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.libTitle),
        actions: [
          if (ref.watch(syncEnCoursProvider))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          if (_modeSelection)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _idsSelectionnes.clear();
                  _modeSelection = false;
                });
              },
              icon: const Icon(Icons.close),
              label: Text(l10n.commonCancel),
            )
          else ...[
            IconButton(
              tooltip: l10n.libViewChange,
              onPressed: () => ref.read(viewModeProvider.notifier).suivant(),
              icon: Icon(switch (ref.watch(viewModeProvider)) {
                ViewMode.grille => Icons.grid_view_rounded,
                ViewMode.liste => Icons.view_agenda_outlined,
                ViewMode.compact => Icons.view_headline_rounded,
              }),
            ),
            Badge(
              isLabelVisible: _filtresActifs > 0,
              label: Text('$_filtresActifs'),
              child: IconButton(onPressed: _showFiltres, icon: const Icon(Icons.tune)),
            ),
          ],
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
                    hintText: l10n.libSearch,
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
                  color: AppColors.danger.withValues(alpha: 0.1),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: AppColors.danger),
                      const SizedBox(width: 8),
                      Text(
                        l10n.libSelectedCount(_idsSelectionnes.length),
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
                title: Text(l10n.commonWarning, style: TextStyle(color: AppColors.danger)),
                content: Text(l10n.libDeleteContent, textAlign: TextAlign.center),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(l10n.commonCancel),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                    onPressed: () async {
                      final dao = ref.read(mangaDaoProvider);
                      for (final id in _idsSelectionnes) {
                        final m = await dao.getManga(id);
                        if (m != null) await CoverService.supprimerCover(m.imagePath);
                      }
                      await dao.deleteMangas(_idsSelectionnes.toList());
                      setState(() {
                        _idsSelectionnes.clear();
                        _modeSelection = false;
                      });
                      messenger.showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.success,
                          content: Text(
                            l10n.libDeleteSuccess,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      );
                      nav.pop();
                    },
                    child: Text(l10n.commonDelete),
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
        error: (e, st) => Center(child: Text('${l10n.commonWarning} $e')),
        data: (liste) {
          final listeFiltree = liste.where((m) {
            if (_recherche.isNotEmpty && !m.titre.toLowerCase().contains(_recherche)) return false;
            if (_filtreStatus != null && m.status != _filtreStatus) return false;
            if (_filtreType != null && m.typeManga != _filtreType) return false;
            if (_filtreFavori != null && m.estFavori != _filtreFavori) return false;
            if (m.note < _filtreNote.start || m.note > _filtreNote.end) return false;
            if (m.chapitres < _filtreChapitres.start) return false;
            if (_filtreChapitres.end < 1000 && m.chapitres > _filtreChapitres.end) return false;
            return true;
          }).toList();

          switch (_tri) {
            case TriOption.titreAZ:
              listeFiltree.sort((a, b) => a.titre.compareTo(b.titre));
            case TriOption.titreZA:
              listeFiltree.sort((a, b) => b.titre.compareTo(a.titre));
            case TriOption.meilleureNote:
              listeFiltree.sort((a, b) => b.note.compareTo(a.note));
            case TriOption.moinsNote:
              listeFiltree.sort((a, b) => a.note.compareTo(b.note));
            case TriOption.plusChapitres:
              listeFiltree.sort((a, b) => b.chapitres.compareTo(a.chapitres));
            case TriOption.moinsChapitres:
              listeFiltree.sort((a, b) => a.chapitres.compareTo(b.chapitres));
            case TriOption.aucun:
              break;
          }

          if (liste.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_stories_outlined, size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(l10n.libEmpty, style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
                  const SizedBox(height: 8),
                  Text(l10n.libEmptyHint, style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
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
                    child: Text(l10n.libNoResult, style: TextStyle(color: Colors.grey.shade400)),
                  ),
                )
              else
                Expanded(child: _buildContenu(listeFiltree, ref.watch(viewModeProvider))),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContenu(List<MangaTableData> liste, ViewMode mode) {
    const padding = EdgeInsets.fromLTRB(12, 4, 12, 80);
    switch (mode) {
      case ViewMode.grille:
        return GridView.builder(
          padding: padding,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: liste.length,
          itemBuilder: (context, i) => _wrapItem(liste[i], MangaCard(mangaData: liste[i])),
        );
      case ViewMode.liste:
        return ListView.separated(
          padding: padding,
          itemCount: liste.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) => _wrapItem(liste[i], MangaListTile(mangaData: liste[i])),
        );
      case ViewMode.compact:
        return ListView.separated(
          padding: padding,
          itemCount: liste.length,
          separatorBuilder: (_, _) => const SizedBox(height: 6),
          itemBuilder: (context, i) => _wrapItem(liste[i], MangaCompactTile(mangaData: liste[i])),
        );
    }
  }

  Widget _wrapItem(MangaTableData manga, Widget child) {
    final isSelected = _idsSelectionnes.contains(manga.id);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onLongPress: () {
        setState(() {
          _modeSelection = true;
          _idsSelectionnes.add(manga.id);
        });
      },
      onTap: () {
        if (!_modeSelection) {
          Navigator.push(context, fadeScaleRoute(MangaDetailPage(mangaData: manga)));
        } else {
          setState(() {
            if (isSelected) {
              _idsSelectionnes.remove(manga.id);
              if (_idsSelectionnes.isEmpty) _modeSelection = false;
            } else {
              _idsSelectionnes.add(manga.id);
            }
          });
        }
      },
      child: Stack(
        children: [
          child,
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
  }
}

class _FiltreSection extends StatelessWidget {
  final String titre;
  final Widget child;

  const _FiltreSection({required this.titre, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titre,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _TriCycleChip extends StatelessWidget {
  final String baseLabel;
  final TriOption option1;
  final String label1;
  final TriOption option2;
  final String label2;
  final TriOption current;
  final void Function(TriOption) onTap;

  const _TriCycleChip({
    required this.baseLabel,
    required this.option1,
    required this.label1,
    required this.option2,
    required this.label2,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOption1 = current == option1;
    final isOption2 = current == option2;
    final selected = isOption1 || isOption2;
    final displayLabel = isOption1 ? '$baseLabel $label1' : isOption2 ? '$baseLabel $label2' : baseLabel;

    return FilterChip(
      label: Text(displayLabel),
      selected: selected,
      onSelected: (_) {
        if (!selected) {
          onTap(option1);
        } else if (isOption1) {
          onTap(option2);
        } else {
          onTap(TriOption.aucun);
        }
      },
    );
  }
}
