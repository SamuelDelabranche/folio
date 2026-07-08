import 'package:flutter/material.dart';
import 'package:folio/generated/app_localizations.dart';
import 'package:folio/data/models/lien.dart';

Future<Lien?> showAjouterLienDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final nomController = TextEditingController();
  final urlController = TextEditingController();
  String? erreurUrl;

  return showDialog<Lien>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AlertDialog(
        title: Text(l10n.lienDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.lienDialogNom,
                hintText: l10n.lienDialogNomHint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: l10n.lienDialogUrl,
                hintText: l10n.lienDialogUrlHint,
                errorText: erreurUrl,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              final nom = nomController.text.trim();
              final url = urlController.text.trim();
              if (nom.isEmpty || url.isEmpty) return;
              if (!urlEstValide(url)) {
                setDialogState(() => erreurUrl = l10n.lienDialogUrlError);
                return;
              }
              Navigator.pop(ctx, Lien(nom: nom, url: url));
            },
            child: Text(l10n.commonAdd),
          ),
        ],
      ),
    ),
  );
}
