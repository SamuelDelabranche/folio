import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;


class AddMangaPage extends ConsumerStatefulWidget {
  const AddMangaPage({super.key});

  @override
  ConsumerState<AddMangaPage> createState() => _AddMangaPageState();
}

class _AddMangaPageState extends ConsumerState<AddMangaPage> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _chapitreController = TextEditingController();
  final _noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter votre manga")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titreController,
              decoration: InputDecoration(labelText: 'Nom du manga'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Champ requis';
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _chapitreController,
              decoration: InputDecoration(
                labelText: 'Combien de chapitres lus',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Champ requis';
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Votre note'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Champ requis";
                }
                final note = double.tryParse(value);
                if (note == null) {
                  return "Nombre Invalide";
                } else if (note < 0 || note > 10) {
                  return "La note doit être entre 0 et 10";
                } else {
                  return null;
                }
              },
            ),

            ElevatedButton(onPressed: () {
              if (_formKey.currentState!.validate()) {
                final dao = ref.read(mangaDaoProvider);
                dao.insertManga(MangaTableCompanion(
                  id: Value.absent(),
                  titre: Value(_titreController.text),
                  description: Value.absent(),
                  imagePath: Value.absent(),
                  status: Value("En cours"),
                  typeManga: Value("Manga"),
                  estFavori: Value(false),
                  note: Value(double.parse(_noteController.text)),
                  chapitres: Value(double.parse(_chapitreController.text)),
                ));

                Navigator.pop(context);
                ref.invalidate(mangasProvider);
              }
            }, child: Text("Ajouter"))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titreController.dispose();
    _chapitreController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
