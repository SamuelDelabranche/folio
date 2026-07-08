import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

const int render = 2048;
const int output = 1024;

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

bool inMark(double tx, double ty) {
  if (tx >= 46 && tx <= 66 && ty >= 38 && ty <= 124) {
    const r = 6.0;
    if (ty < 38 + r) {
      if (tx < 46 + r && _hors(tx, ty, 46 + r, 38 + r, r)) return false;
      if (tx > 66 - r && _hors(tx, ty, 66 - r, 38 + r, r)) return false;
    }
    if (ty >= 112 + 12 * (tx - 56).abs() / 10) return false;
    return true;
  }
  if (_dansBras(tx, ty, 66, 38, 114, 56)) return true;
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
  final tuile = size / 160;
  final radius = size * 0.225;

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

  final fond = img.Image(width: render, height: render, numChannels: 4);
  for (var py = 0; py < render; py++) {
    for (var px = 0; px < render; px++) {
      final (r, g, b) = gradientAt(px + 0.5, py + 0.5, size);
      fond.setPixelRgba(px, py, r, g, b, 255);
    }
  }
  save(fond, 'assets/splash/logo_background.png');

  final avant = img.Image(width: render, height: render, numChannels: 4);
  final hauteurCible = size * 0.40;
  final echelle = hauteurCible / 86;
  final dx = size / 2 - 80 * echelle;
  final dy = size / 2 - 81 * echelle;
  for (var py = 0; py < render; py++) {
    for (var px = 0; px < render; px++) {
      final tx = (px + 0.5 - dx) / echelle;
      final ty = (py + 0.5 - dy) / echelle;
      if (inMark(tx, ty)) avant.setPixelRgba(px, py, 255, 255, 255, 255);
    }
  }
  save(avant, 'assets/splash/logo_foreground.png');
}
