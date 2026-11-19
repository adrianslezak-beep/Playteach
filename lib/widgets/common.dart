import 'dart:math';

import 'package:flutter/material.dart';

const List<String> praises = [
  'Brawo!', 'Super!', 'Świetnie!', 'Ekstra!', 'Wspaniale!', 'Mistrzostwo!', 'Tak trzymać!', 'Doskonale!', 'Rewelacja!',
];

String randomPraise() => praises[Random().nextInt(praises.length)];

double gradeScale(int grade) => grade <= 1 ? 1.2 : (grade == 2 ? 1.1 : 1.0);

const List<List<Color>> cardGradients = [
  [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
  [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
  [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
  [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
  [Color(0xFFFFFDE7), Color(0xFFFFF59D)],
  [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
  [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
];

/// Treść wyśrodkowana, ale przewijana, gdy się nie mieści.
class ScrollCenter extends StatelessWidget {
  final Widget child;
  const ScrollCenter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: c.maxHeight, minWidth: c.maxWidth),
          child: Center(child: child),
        ),
      );
    });
  }
}

/// Potrząśnięcie przy złej odpowiedzi (bez kar – tylko delikatny sygnał).
class Shake extends StatelessWidget {
  final int trigger;
  final Widget child;
  const Shake({super.key, required this.trigger, required this.child});

  @override
  Widget build(BuildContext context) {
    if (trigger == 0) return child;
    return TweenAnimationBuilder<double>(
      key: ValueKey(trigger),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      builder: (context, v, ch) {
        final dx = sin(v * pi * 6) * 10 * (1 - v);
        return Transform.translate(offset: Offset(dx, 0), child: ch);
      },
      child: child,
    );
  }
}

class FeedbackArea extends StatelessWidget {
  final bool solved;
  final String praise;
  final String explain;
  final String hint;
  final bool showHint;
  final bool tryAgain;
  final bool swipeHint;
  final double scale;

  const FeedbackArea({
    super.key,
    required this.solved,
    required this.praise,
    this.explain = '',
    this.hint = '',
    this.showHint = false,
    this.tryAgain = false,
    this.swipeHint = true,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (solved) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.3, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, v, ch) => Transform.scale(scale: v, child: ch),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('⭐ $praise ⭐',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30 * scale, fontWeight: FontWeight.w900, color: const Color(0xFF2E7D32))),
            if (explain.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(explain,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.w600, color: Colors.black87)),
              ),
            if (swipeHint)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('Przesuń w górę po następne ⬆', style: TextStyle(color: Colors.black54)),
              ),
          ],
        ),
      );
    }
    if (showHint && hint.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(220),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text('💡 $hint', textAlign: TextAlign.center, style: TextStyle(fontSize: 16 * scale)),
      );
    }
    if (tryAgain) {
      return Text('Prawie! Spróbuj jeszcze raz 🙂',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.w600, color: const Color(0xFF6D4C41)));
    }
    return const SizedBox(height: 24);
  }
}

/// Figura geometryczna jako odpowiedź (klasa 1).
class ShapeIcon extends StatelessWidget {
  final String kind;
  final double size;
  final Color color;
  const ShapeIcon({super.key, required this.kind, this.size = 56, this.color = const Color(0xFF5C6BC0)});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _ShapeIconPainter(kind, color));
  }
}

class _ShapeIconPainter extends CustomPainter {
  final String kind;
  final Color color;
  _ShapeIconPainter(this.kind, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final p = Paint()..color = color;
    switch (kind) {
      case 'circle':
        canvas.drawCircle(Offset(s / 2, s / 2), s * 0.42, p);
        break;
      case 'square':
        canvas.drawRect(Rect.fromLTWH(s * 0.1, s * 0.1, s * 0.8, s * 0.8), p);
        break;
      case 'triangle':
        canvas.drawPath(
            Path()
              ..moveTo(s * 0.5, s * 0.08)
              ..lineTo(s * 0.95, s * 0.9)
              ..lineTo(s * 0.05, s * 0.9)
              ..close(),
            p);
        break;
      default: // rect
        canvas.drawRect(Rect.fromLTWH(0, s * 0.25, s, s * 0.5), p);
    }
  }

  @override
  bool shouldRepaint(covariant _ShapeIconPainter old) => old.kind != kind || old.color != color;
}

class SubjectChip extends StatelessWidget {
  final String subject;
  const SubjectChip({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (subject) {
      'math' => ('🔢 Matematyka', const Color(0xFF1E88E5)),
      'polish' => ('📝 Polski', const Color(0xFFD81B60)),
      _ => ('🎨 Plastyka', const Color(0xFF8E24AA)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
