import 'dart:math';

import 'package:flutter/material.dart';

import '../content/shapes.dart';
import '../models.dart';
import '../speaker.dart';
import 'common.dart';

class _Stroke {
  final Color color;
  final List<Offset> pts = [];
  _Stroke(this.color);
}

/// Rysowanie po śladzie, a potem kolorowanie kredką.
class TraceCard extends StatefulWidget {
  final Task task;
  final int grade;
  final bool swipeHint;
  final void Function(int mistakes) onSolved;
  final VoidCallback? onSkip;

  const TraceCard({
    super.key,
    required this.task,
    required this.grade,
    required this.onSolved,
    this.onSkip,
    this.swipeHint = true,
  });

  @override
  State<TraceCard> createState() => _TraceCardState();
}

class _TraceCardState extends State<TraceCard> {
  late final ShapeDef shape = shapeById(widget.task.shape);
  late final List<Offset> samples = _buildSamples();
  final List<List<Offset>> traceStrokes = [];
  final List<_Stroke> colorStrokes = [];
  int stage = 0; // 0 = ślad, 1 = kolorowanie, 2 = gotowe
  double coverage = 0;
  late Color crayon = shape.color;
  int colorPoints = 0;
  String praise = '';
  int _moveCount = 0;

  List<Offset> _buildSamples() {
    final paths = <Path>[shape.outline(1.0)];
    if (shape.extra != null) paths.add(shape.extra!(1.0));
    double total = 0;
    for (final p in paths) {
      for (final m in p.computeMetrics()) {
        total += m.length;
      }
    }
    final step = total / 90;
    final out = <Offset>[];
    for (final p in paths) {
      for (final m in p.computeMetrics()) {
        for (double t = 0; t < m.length; t += step) {
          final tan = m.getTangentForOffset(t);
          if (tan != null) out.add(tan.position);
        }
      }
    }
    return out;
  }

  double _coverage() {
    if (samples.isEmpty) return 1;
    const tol = 0.075;
    const tol2 = tol * tol;
    int hit = 0;
    for (final s in samples) {
      bool ok = false;
      for (final st in traceStrokes) {
        for (final p in st) {
          final dx = p.dx - s.dx;
          final dy = p.dy - s.dy;
          if (dx * dx + dy * dy < tol2) {
            ok = true;
            break;
          }
        }
        if (ok) break;
      }
      if (ok) hit++;
    }
    return hit / samples.length;
  }

  void _updateCoverage() {
    coverage = _coverage();
    if (coverage >= 0.82 && stage == 0) {
      stage = 1;
      final msg = 'Pięknie! Teraz weź ${shape.colorAcc} kredkę i pokoloruj ${shape.acc}.';
      Speaker.speak(msg);
    }
  }

  void _down(Offset unit) {
    if (stage == 0) {
      traceStrokes.add([unit]);
    } else if (stage == 1) {
      colorStrokes.add(_Stroke(crayon)..pts.add(unit));
      colorPoints++;
    }
    setState(() {});
  }

  void _move(Offset unit) {
    if (stage == 0 && traceStrokes.isNotEmpty) {
      traceStrokes.last.add(unit);
      _moveCount++;
      if (_moveCount % 8 == 0) _updateCoverage();
    } else if (stage == 1 && colorStrokes.isNotEmpty) {
      colorStrokes.last.pts.add(unit);
      colorPoints++;
    }
    setState(() {});
  }

  void _up() {
    if (stage == 0) {
      setState(_updateCoverage);
    }
  }

  void _clear() {
    setState(() {
      if (stage == 0) {
        traceStrokes.clear();
        coverage = 0;
      } else if (stage == 1) {
        colorStrokes.clear();
        colorPoints = 0;
      }
    });
  }

  void _finish() {
    setState(() {
      stage = 2;
      praise = randomPraise();
    });
    Speaker.speak('$praise Piękny rysunek!');
    widget.onSolved(0);
  }

  @override
  Widget build(BuildContext context) {
    final sc = gradeScale(widget.grade);
    final title = stage == 0
        ? widget.task.prompt
        : (stage == 1 ? 'Weź ${shape.colorAcc} kredkę i pokoloruj ${shape.acc}' : 'Piękny rysunek!');
    return Column(
      children: [
        Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22 * sc, fontWeight: FontWeight.w700, color: const Color(0xFF37474F))),
        const SizedBox(height: 8),
        Expanded(
          child: LayoutBuilder(builder: (context, c) {
            final side = min(c.maxWidth, c.maxHeight);
            return Center(
              child: SizedBox(
                width: side,
                height: side,
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (e) => _down(e.localPosition / side),
                  onPointerMove: (e) => _move(e.localPosition / side),
                  onPointerUp: (_) => _up(),
                  child: CustomPaint(
                    painter: _TracePainter(
                      shape: shape,
                      stage: stage,
                      traceStrokes: traceStrokes,
                      colorStrokes: colorStrokes,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        if (stage == 0) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (coverage / 0.82).clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: Colors.white,
              color: const Color(0xFF66BB6A),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(onPressed: _clear, icon: const Icon(Icons.refresh), label: const Text('Od nowa')),
              if (widget.onSkip != null)
                TextButton.icon(
                    onPressed: widget.onSkip, icon: const Icon(Icons.skip_next), label: const Text('Pomiń')),
            ],
          ),
        ],
        if (stage == 1) ...[
          SizedBox(
            height: 54,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                for (final col in crayons)
                  GestureDetector(
                    onTap: () => setState(() => crayon = col),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: crayon == col ? 50 : 40,
                      height: crayon == col ? 50 : 40,
                      decoration: BoxDecoration(
                        color: col,
                        shape: BoxShape.circle,
                        border: Border.all(color: crayon == col ? Colors.black87 : Colors.white, width: 3),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(onPressed: _clear, icon: const Icon(Icons.refresh), label: const Text('Wymaż')),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: colorPoints >= 25 ? _finish : null,
                icon: const Icon(Icons.check),
                label: const Text('Gotowe!', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ],
        if (stage == 2)
          FeedbackArea(solved: true, praise: praise, swipeHint: widget.swipeHint, scale: sc),
      ],
    );
  }
}

class _TracePainter extends CustomPainter {
  final ShapeDef shape;
  final int stage;
  final List<List<Offset>> traceStrokes;
  final List<_Stroke> colorStrokes;

  _TracePainter({
    required this.shape,
    required this.stage,
    required this.traceStrokes,
    required this.colorStrokes,
  });

  Path _poly(List<Offset> pts, double side) {
    final p = Path()..moveTo(pts.first.dx * side, pts.first.dy * side);
    for (final o in pts.skip(1)) {
      p.lineTo(o.dx * side, o.dy * side);
    }
    return p;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.width;
    final rect = Offset.zero & size;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(24)), Paint()..color = Colors.white);

    final outline = shape.outline(side);
    final extra = shape.extra?.call(side);

    if (stage == 0) {
      final dot = Paint()..color = const Color(0xFF9E9E9E);
      final paths = <Path>[outline, if (extra != null) extra];
      final gap = side * 0.03;
      for (final p in paths) {
        for (final m in p.computeMetrics()) {
          for (double t = 0; t < m.length; t += gap) {
            final tan = m.getTangentForOffset(t);
            if (tan != null) canvas.drawCircle(tan.position, side * 0.009, dot);
          }
        }
      }
      final pen = Paint()
        ..color = const Color(0xB31E88E5)
        ..strokeWidth = side * 0.035
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      for (final st in traceStrokes) {
        if (st.length == 1) {
          canvas.drawCircle(Offset(st.first.dx * side, st.first.dy * side), side * 0.0175, pen..style = PaintingStyle.fill);
          pen.style = PaintingStyle.stroke;
        } else {
          canvas.drawPath(_poly(st, side), pen);
        }
      }
      return;
    }

    // Kolorowanie – kredka nie wychodzi poza kontur.
    canvas.save();
    canvas.clipPath(outline);
    for (final st in colorStrokes) {
      final paint = Paint()
        ..color = st.color.withAlpha(215)
        ..strokeWidth = side * 0.07
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      if (st.pts.length == 1) {
        canvas.drawCircle(Offset(st.pts.first.dx * side, st.pts.first.dy * side), side * 0.035,
            Paint()..color = st.color.withAlpha(215));
      } else {
        canvas.drawPath(_poly(st.pts, side), paint);
      }
    }
    canvas.restore();

    final line = Paint()
      ..color = const Color(0xFF263238)
      ..strokeWidth = side * 0.013
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(outline, line);
    if (extra != null) canvas.drawPath(extra, line);
  }

  @override
  bool shouldRepaint(covariant _TracePainter oldDelegate) => true;
}
