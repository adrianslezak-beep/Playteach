import 'dart:math' as math;

import 'package:flutter/material.dart';

const Color crayonRed = Color(0xFFE53935);
const Color crayonOrange = Color(0xFFFB8C00);
const Color crayonYellow = Color(0xFFFDD835);
const Color crayonGreen = Color(0xFF43A047);
const Color crayonBlue = Color(0xFF1E88E5);
const Color crayonPurple = Color(0xFF8E24AA);
const Color crayonPink = Color(0xFFEC407A);
const Color crayonBrown = Color(0xFF795548);

const List<Color> crayons = [
  crayonRed, crayonOrange, crayonYellow, crayonGreen, crayonBlue, crayonPurple, crayonPink, crayonBrown,
];

/// Kształt do rysowania po śladzie. Ścieżki w skali 0..s.
class ShapeDef {
  final String id;
  final String acc; // biernik: "jabłko", "gwiazdkę"
  final String colorAcc; // "czerwoną"
  final Color color;
  final Path Function(double s) outline;
  final Path Function(double s)? extra;
  ShapeDef(this.id, this.acc, this.colorAcc, this.color, this.outline, [this.extra]);
}

Path _apple(double s) => Path()
  ..moveTo(0.5 * s, 0.28 * s)
  ..cubicTo(0.35 * s, 0.18 * s, 0.08 * s, 0.22 * s, 0.1 * s, 0.5 * s)
  ..cubicTo(0.12 * s, 0.8 * s, 0.3 * s, 0.95 * s, 0.42 * s, 0.92 * s)
  ..cubicTo(0.47 * s, 0.9 * s, 0.53 * s, 0.9 * s, 0.58 * s, 0.92 * s)
  ..cubicTo(0.7 * s, 0.95 * s, 0.88 * s, 0.8 * s, 0.9 * s, 0.5 * s)
  ..cubicTo(0.92 * s, 0.22 * s, 0.65 * s, 0.18 * s, 0.5 * s, 0.28 * s)
  ..close();

Path _appleExtra(double s) => Path()
  ..moveTo(0.5 * s, 0.28 * s)
  ..lineTo(0.54 * s, 0.1 * s)
  ..moveTo(0.53 * s, 0.17 * s)
  ..cubicTo(0.6 * s, 0.06 * s, 0.73 * s, 0.07 * s, 0.78 * s, 0.11 * s)
  ..cubicTo(0.7 * s, 0.2 * s, 0.6 * s, 0.21 * s, 0.53 * s, 0.17 * s);

Path _heart(double s) => Path()
  ..moveTo(0.5 * s, 0.88 * s)
  ..cubicTo(0.1 * s, 0.62 * s, 0.03 * s, 0.32 * s, 0.25 * s, 0.2 * s)
  ..cubicTo(0.38 * s, 0.13 * s, 0.5 * s, 0.22 * s, 0.5 * s, 0.32 * s)
  ..cubicTo(0.5 * s, 0.22 * s, 0.62 * s, 0.13 * s, 0.75 * s, 0.2 * s)
  ..cubicTo(0.97 * s, 0.32 * s, 0.9 * s, 0.62 * s, 0.5 * s, 0.88 * s)
  ..close();

Path _star(double s) {
  final p = Path();
  for (int i = 0; i < 10; i++) {
    final r = (i.isEven ? 0.44 : 0.19) * s;
    final a = -math.pi / 2 + i * math.pi / 5;
    final x = 0.5 * s + r * math.cos(a);
    final y = 0.54 * s + r * math.sin(a);
    if (i == 0) {
      p.moveTo(x, y);
    } else {
      p.lineTo(x, y);
    }
  }
  p.close();
  return p;
}

Path _house(double s) => Path()
  ..moveTo(0.18 * s, 0.46 * s)
  ..lineTo(0.5 * s, 0.14 * s)
  ..lineTo(0.82 * s, 0.46 * s)
  ..lineTo(0.82 * s, 0.88 * s)
  ..lineTo(0.18 * s, 0.88 * s)
  ..close();

Path _houseExtra(double s) => Path()..addRect(Rect.fromLTRB(0.42 * s, 0.66 * s, 0.58 * s, 0.88 * s));

Path _fish(double s) => Path()
  ..moveTo(0.1 * s, 0.5 * s)
  ..cubicTo(0.25 * s, 0.22 * s, 0.58 * s, 0.22 * s, 0.7 * s, 0.5 * s)
  ..lineTo(0.92 * s, 0.3 * s)
  ..lineTo(0.92 * s, 0.7 * s)
  ..lineTo(0.7 * s, 0.5 * s)
  ..cubicTo(0.58 * s, 0.78 * s, 0.25 * s, 0.78 * s, 0.1 * s, 0.5 * s)
  ..close();

Path _fishExtra(double s) =>
    Path()..addOval(Rect.fromCircle(center: Offset(0.27 * s, 0.46 * s), radius: 0.035 * s));

Path _balloon(double s) => Path()..addOval(Rect.fromLTRB(0.24 * s, 0.06 * s, 0.76 * s, 0.68 * s));

Path _balloonExtra(double s) => Path()
  ..moveTo(0.5 * s, 0.68 * s)
  ..cubicTo(0.43 * s, 0.78 * s, 0.57 * s, 0.86 * s, 0.5 * s, 0.96 * s);

Path _sun(double s) => Path()..addOval(Rect.fromCircle(center: Offset(0.5 * s, 0.5 * s), radius: 0.24 * s));

Path _sunRays(double s) {
  final p = Path();
  for (int i = 0; i < 8; i++) {
    final a = i * math.pi / 4;
    p.moveTo(0.5 * s + 0.32 * s * math.cos(a), 0.5 * s + 0.32 * s * math.sin(a));
    p.lineTo(0.5 * s + 0.46 * s * math.cos(a), 0.5 * s + 0.46 * s * math.sin(a));
  }
  return p;
}

Path _leaf(double s) => Path()
  ..moveTo(0.15 * s, 0.85 * s)
  ..cubicTo(0.12 * s, 0.35 * s, 0.5 * s, 0.12 * s, 0.88 * s, 0.12 * s)
  ..cubicTo(0.88 * s, 0.5 * s, 0.65 * s, 0.88 * s, 0.15 * s, 0.85 * s)
  ..close();

Path _leafExtra(double s) => Path()
  ..moveTo(0.15 * s, 0.85 * s)
  ..lineTo(0.72 * s, 0.3 * s);

Path _circle(double s) => Path()..addOval(Rect.fromCircle(center: Offset(0.5 * s, 0.5 * s), radius: 0.38 * s));

Path _triangle(double s) => Path()
  ..moveTo(0.5 * s, 0.1 * s)
  ..lineTo(0.9 * s, 0.85 * s)
  ..lineTo(0.1 * s, 0.85 * s)
  ..close();

Path _square(double s) => Path()..addRect(Rect.fromLTRB(0.15 * s, 0.15 * s, 0.85 * s, 0.85 * s));

final List<ShapeDef> traceShapes = [
  ShapeDef('apple', 'jabłko', 'czerwoną', crayonRed, _apple, _appleExtra),
  ShapeDef('heart', 'serce', 'czerwoną', crayonRed, _heart),
  ShapeDef('star', 'gwiazdkę', 'żółtą', crayonYellow, _star),
  ShapeDef('house', 'domek', 'niebieską', crayonBlue, _house, _houseExtra),
  ShapeDef('fish', 'rybkę', 'pomarańczową', crayonOrange, _fish, _fishExtra),
  ShapeDef('balloon', 'balonik', 'różową', crayonPink, _balloon, _balloonExtra),
  ShapeDef('sun', 'słoneczko', 'żółtą', crayonYellow, _sun, _sunRays),
  ShapeDef('leaf', 'listek', 'zieloną', crayonGreen, _leaf, _leafExtra),
  ShapeDef('circle', 'koło', 'zieloną', crayonGreen, _circle),
  ShapeDef('triangle', 'trójkąt', 'fioletową', crayonPurple, _triangle),
  ShapeDef('square', 'kwadrat', 'niebieską', crayonBlue, _square),
];

ShapeDef shapeById(String id) =>
    traceShapes.firstWhere((s) => s.id == id, orElse: () => traceShapes.first);
