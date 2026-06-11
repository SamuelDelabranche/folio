// Génère les assets du logo Folio (F marque-page sur dégradé violet→magenta).
// Usage : dart run tool/generate_logo.dart
//
// Produit dans assets/splash/ :
//   logo.png            — tuile arrondie dégradée + F blanc (icône legacy + splash)
//   logo_foreground.png — F blanc seul, centré dans la safe-zone (adaptive icon)
//   logo_background.png — dégradé plein cadre (adaptive icon)
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

// Rendu en 2048 puis réduction à 1024 pour lisser les bords.
const int render = 2048;
const int output = 1024;

// Couleurs de la charte (AppColors.primary / AppColors.accent).
const _violet = (0x7C, 0x3A, 0xED);
const _magenta = (0xEC, 0x48, 0x99);

(int, int, int) gradientAt(double x, double y, double size) {
  final t = ((x + y) / (2 * size)).clamp(0.0, 1.0);
  return (
    (_violet.$1 + (_magenta.$1 - _violet.$1) * t).round(),
    (_violet.$2 + (_magenta.$2 - _violet.$2) * t).round(),
    (_violet.$3 + (_magenta.$3 - _violet.$3) * t).round(),
  );
}

/// Le F marque-page en coordonnées "tuile 160" (mêmes proportions que la
/// maquette validée) : barre verticale avec encoche en V + deux bras.
bool inMark(double tx, double ty) {
  // Barre verticale (marque-page) : x 46..66, y 38..124, coins hauts arrondis.
  if (tx >= 46 && tx <= 66 && ty >= 38 && ty <= 124) {
    const r = 6.0;
    if (ty < 38 + r) {
      if (tx < 46 + r && _hors(tx, ty, 46 + r, 38 + r, r)) return false;
      if (tx > 66 - r && _hors(tx, ty, 66 - r, 38 + r, r)) return false;
    }
    // Encoche en V : sommet (56,112), base (46,124)-(66,124).
    if (ty >= 112 + 12 * (tx - 56).abs() / 10) return false;
    return true;
  }
  // Bras supérieur : x 66..114, y 38..56, coins droits arrondis.
  if (_dansBras(tx, ty, 66, 38, 114, 56)) return true;
  // Bras central : x 66..102, y 70..88.
  if (_dansBras(tx, ty, 66, 70, 102, 88)) return true;
  return false;
}

bool _hors(double x, double y, double cx, double cy, double r) =>
    sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy)) > r;

bool _dansBras(double x, double y, double x1, double y1, double x2, double y2) {
  if (x < x1 || x > x2 || y < y1 || y > y2) return false;
  const r = 6.0;
  if (x > x2 - r && y < y1 + r && _hors(x, y, x2 - r, y1 + r, r)) return false;
  if (x > x2 - r && y > y2 - r && _hors(x, y, x2 - r, y2 - r, r)) return false;
  return true;
}

bool inRoundedSquare(double x, double y, double size, double radius) {
  if (x < 0 || y < 0 || x > size || y > size) return false;
  final cx = x < radius ? radius : (x > size - radius ? size - radius : x);
  final cy = y < radius ? radius : (y > size - radius ? size - radius : y);
  if ((cx == x) || (cy == y)) return true;
  return !_hors(x, y, cx, cy, radius);
}

void save(img.Image image, String path) {
  final reduit = img.copyResize(image, width: output, height: output,
      interpolation: img.Interpolation.cubic);
  File(path).writeAsBytesSync(img.encodePng(reduit));
  stdout.writeln('OK $path');
}

void main() {
  final size = render.toDouble();
  final tuile = size / 160; // échelle coordonnées tuile → pixels
  final radius = size * 0.225;

  // ── logo.png : tuile arrondie + F blanc ──
  final logo = img.Image(width: render, height: render, numChannels: 4);
  for (var py = 0; py < render; py++) {
    for (var px = 0; px < render; px++) {
      final x = px + 0.5, y = py + 0.5;
      if (!inRoundedSquare(x, y, size, radius)) continue;
      if (inMark(x / tuile, y / tuile)) {
        logo.setPixelRgba(px, py, 255, 255, 255, 255);
      } else {
        final (r, g, b) = gradientAt(x, y, size);
        logo.setPixelRgba(px, py, r, g, b, 255);
      }
    }
  }
  save(logo, 'assets/splash/logo.png');

  // ── logo_background.png : dégradé plein cadre ──
  final fond = img.Image(width: render, height: render, numChannels: 4);
  for (var py = 0; py < render; py++) {
    for (var px = 0; px < render; px++) {
      final (r, g, b) = gradientAt(px + 0.5, py + 0.5, size);
      fond.setPixelRgba(px, py, r, g, b, 255);
    }
  }
  save(fond, 'assets/splash/logo_background.png');

  // ── logo_foreground.png : F blanc seul, ~40% de hauteur (safe-zone 66%) ──
  final avant = img.Image(width: render, height: render, numChannels: 4);
  // bbox du F en coordonnées tuile : x 46..114, y 38..124
  final hauteurCible = size * 0.40;
  final echelle = hauteurCible / 86; // 86 = hauteur du F en unités tuile
  final dx = size / 2 - 80 * echelle; // 80 = centre x du F
  final dy = size / 2 - 81 * echelle; // 81 = centre y du F
  for (var py = 0; py < render; py++) {
    for (var px = 0; px < render; px++) {
      final tx = (px + 0.5 - dx) / echelle;
      final ty = (py + 0.5 - dy) / echelle;
      if (inMark(tx, ty)) avant.setPixelRgba(px, py, 255, 255, 255, 255);
    }
  }
  save(avant, 'assets/splash/logo_foreground.png');
}
