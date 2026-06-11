import 'dart:convert';

class Lien {
  final String nom;
  final String url;

  const Lien({required this.nom, required this.url});

  factory Lien.fromMap(Map<String, dynamic> map) =>
      Lien(nom: map['nom'] as String, url: map['url'] as String);

  Map<String, dynamic> toMap() => {'nom': nom, 'url': url};
}

List<Lien> liensFromJson(String? json) {
  if (json == null || json.isEmpty) return [];
  final list = jsonDecode(json) as List<dynamic>;
  return list.map((e) => Lien.fromMap(e as Map<String, dynamic>)).toList();
}

String liensToJson(List<Lien> liens) =>
    jsonEncode(liens.map((l) => l.toMap()).toList());

/// Seuls http/https sont autorisés : bloque les schemes dangereux
/// (file://, javascript:, intent://...) qui pourraient arriver
/// via un fichier d'import partagé.
bool urlEstValide(String url) {
  final uri = Uri.tryParse(url.trim());
  return uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
}
