import 'package:flutter/material.dart';
import 'package:folio/data/models/lien.dart';

Future<Lien?> showAjouterLienDialog(BuildContext context) {
  final nomController = TextEditingController();
  final urlController = TextEditingController();
  String? erreurUrl;

  return showDialog<Lien>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AlertDialog(
        title: const Text('Ajouter un lien'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Nom',
                hintText: 'ex: Scan VF',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: 'URL',
                hintText: 'https://...',
                errorText: erreurUrl,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              final nom = nomController.text.trim();
              final url = urlController.text.trim();
              if (nom.isEmpty || url.isEmpty) return;
              if (!urlEstValide(url)) {
                setDialogState(() => erreurUrl = 'URL invalide (http/https requis)');
                return;
              }
              Navigator.pop(ctx, Lien(nom: nom, url: url));
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    ),
  );
}
