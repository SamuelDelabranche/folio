import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:folio/app/providers.dart';
import 'package:folio/data/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;

const List<String> tousLesGenres = [
  'Action',
  'Aventure',
  'Arts martiaux',
  'Sports',
  'Romance',
  'Comédie',
  'Drame',
  'Tranche de vie',
  'Mystère',
  'Thriller',
  'Horreur',
  'Psychologique',
  'Fantaisie',
  'Science-fiction',
  'Isekai',
  'Surnaturel',
  'Mecha',
  'Magie',
  'Historique',
  'Musique',
  'Cuisine',
  'Jeux',
  'Ecchi',
  'Harem',
  'Shonen',
  'Shojo',
  'Seinen',
  'Josei',
  'Kodomomuke',
  'Yaoi',
  'Yuri',
  'Gore',
  'Militaire',
  'Politique',
];

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
  final _rechercheController = TextEditingController();
  String _rechercheGenre = '';
  String _statusSelectionne = 'En cours';
  String _typeSelectionne = 'Manga';
  List<String> _genreSelectionne = [];
  bool _estFavori = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter votre manga")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
              DropdownButtonFormField<String>(
                initialValue: _statusSelectionne,
                decoration: InputDecoration(labelText: 'Statut'),
                items: ['À lire', 'En cours', 'Terminé', 'Abandonné']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _statusSelectionne = value!;
                  });
                },
              ),
              DropdownButtonFormField(
                initialValue: _typeSelectionne,
                decoration: InputDecoration(labelText: 'Type'),
                items: ['Manga', 'Manhwa', 'Manhua', 'Novel']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _typeSelectionne = value!;
                  });
                },
              ),
              TextField(
                controller: _rechercheController,
                decoration: InputDecoration(
                  labelText: "Rechercher un genre",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _rechercheGenre = value.toLowerCase();
                  });
                },
              ),
              Wrap(
                spacing: 8,
                children: tousLesGenres.where((g) => g.toLowerCase().contains(_rechercheGenre))
                    .map(
                      (genre) => FilterChip(
                        label: Text(genre),
                        selected: _genreSelectionne.contains(genre),
                        onSelected: (selected) {
                          setState(() {
                            selected
                                ? _genreSelectionne.add(genre)
                                : _genreSelectionne.remove(genre);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),

              SwitchListTile(
                title: Text("Favori"),
                value: _estFavori,
                onChanged: (value) => setState(() {
                  _estFavori = value;
                }),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final dao = ref.read(mangaDaoProvider);
                    dao.insertManga(
                      MangaTableCompanion(
                        id: Value.absent(),
                        titre: Value(_titreController.text),
                        description: Value.absent(),
                        imagePath: Value.absent(),
                        status: Value(_statusSelectionne),
                        typeManga: Value(_typeSelectionne),
                        estFavori: Value(_estFavori),
                        note: Value(double.parse(_noteController.text)),
                        chapitres: Value(
                          double.parse(_chapitreController.text),
                        ),
                        genre: Value(_genreSelectionne.join(',')),
                      ),
                    );

                    Navigator.pop(context);
                    ref.invalidate(mangasProvider);
                  }
                },
                child: Text("Ajouter"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titreController.dispose();
    _chapitreController.dispose();
    _noteController.dispose();
    _rechercheController.dispose();
    super.dispose();
  }
}
