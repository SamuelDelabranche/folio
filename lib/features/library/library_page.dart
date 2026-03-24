import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Folio'),
          ),

          body: Center(
            child: Text("Ma Bibliothèque"),
          ),
    );
  }

}