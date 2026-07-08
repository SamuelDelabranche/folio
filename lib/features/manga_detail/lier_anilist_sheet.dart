import 'dart:async';

import 'package:flutter/material.dart';
import 'package:folio/generated/app_localizations.dart';
import 'package:folio/app/theme.dart';
import 'package:folio/services/anilist/anilist_client.dart';
import 'package:folio/services/anilist/anilist_models.dart';
import 'package:folio/services/anilist/sync_service.dart';

Future<AnilistSearchResult?> showLierAnilistSheet(
  BuildContext context,
  String titreInitial,
) {
  return showModalBottomSheet<AnilistSearchResult>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _LierAnilistSheet(titreInitial: titreInitial),
  );
}

class _LierAnilistSheet extends StatefulWidget {
  final String titreInitial;
  const _LierAnilistSheet({required this.titreInitial});

  @override
  State<_LierAnilistSheet> createState() => _LierAnilistSheetState();
}

class _LierAnilistSheetState extends State<_LierAnilistSheet> {
  late final TextEditingController _controller;
  final _client = AnilistClient();
  Timer? _debounce;
  List<AnilistSearchResult> _resultats = [];
  bool _chargement = false;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.titreInitial);
    _rechercher();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _client.dispose();
    super.dispose();
  }

  void _onTexteChange(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), _rechercher);
  }

  Future<void> _rechercher() async {
    final l10n = AppLocalizations.of(context)!;
    final titre = _controller.text.trim();
    if (titre.isEmpty) return;
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      final resultats = await _client.search(titre);
      if (!mounted) return;
      setState(() {
        _resultats = resultats;
        _chargement = false;
      });
    } on AnilistRateLimitException catch (e) {
      if (!mounted) return;
      setState(() {
        _chargement = false;
        _erreur = l10n.anilistSheetRateLimit(e.retryAfter.inSeconds);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _chargement = false;
        _erreur = AppLocalizations.of(context)!.anilistSheetNetworkError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              l10n.anilistSheetTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _controller,
                onChanged: _onTexteChange,
                onSubmitted: (_) => _rechercher(),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.anilistSheetHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _rechercher,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
              ),
            ),
            Expanded(child: _buildContenu(l10n)),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  l10n.anilistSheetPoweredBy,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContenu(AppLocalizations l10n) {
    if (_chargement) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_erreur != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 40, color: Colors.grey.shade500),
            const SizedBox(height: 12),
            Text(_erreur!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _rechercher, child: Text(l10n.anilistSheetRetry)),
          ],
        ),
      );
    }
    if (_resultats.isEmpty) {
      return Center(
        child: Text(l10n.anilistSheetNoResult, style: TextStyle(color: Colors.grey.shade500)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _resultats.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final r = _resultats[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 42,
              height: 58,
              child: r.vignetteUrl != null && urlCoverAutorisee(r.vignetteUrl!)
                  ? Image.network(
                      r.vignetteUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const _VignetteDefaut(),
                    )
                  : const _VignetteDefaut(),
            ),
          ),
          title: Text(r.titre, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(r.sousTitre, style: const TextStyle(fontSize: 12)),
          trailing: const Icon(Icons.add_link),
          onTap: () => Navigator.pop(context, r),
        );
      },
    );
  }
}

class _VignetteDefaut extends StatelessWidget {
  const _VignetteDefaut();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.15),
      child: const Icon(Icons.menu_book_outlined, size: 20, color: AppColors.primary),
    );
  }
}
