import 'dart:math';

import 'package:flutter/material.dart';

import '../models.dart';
import '../speaker.dart';
import 'common.dart';

/// Układanie elementów w kolejności (litery w słowo, wyrazy w zdanie, alfabet).
class OrderCard extends StatefulWidget {
  final Task task;
  final int grade;
  final bool swipeHint;
  final void Function(int mistakes) onSolved;

  const OrderCard({super.key, required this.task, required this.grade, required this.onSolved, this.swipeHint = true});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late List<int> pool;
  final List<int> placed = [];
  bool solved = false;
  int mistakes = 0;
  int shake = 0;
  String praise = '';

  List<String> get pieces => widget.task.pieces;

  @override
  void initState() {
    super.initState();
    final r = Random();
    pool = List<int>.generate(pieces.length, (i) => i);
    for (int k = 0; k < 10; k++) {
      pool.shuffle(r);
      if (!_sameAsCorrect(pool)) break;
    }
  }

  bool _sameAsCorrect(List<int> order) {
    if (order.length != pieces.length) return false;
    for (int i = 0; i < order.length; i++) {
      if (pieces[order[i]] != pieces[i]) return false;
    }
    return true;
  }

  void _place(int k) {
    if (solved) return;
    setState(() {
      placed.add(pool.removeAt(k));
    });
    if (pool.isEmpty) _check();
  }

  void _unplace(int k) {
    if (solved) return;
    setState(() {
      pool.add(placed.removeAt(k));
    });
  }

  void _check() {
    if (_sameAsCorrect(placed)) {
      setState(() {
        solved = true;
        praise = randomPraise();
      });
      Speaker.speak('$praise ${widget.task.explain}');
      widget.onSolved(mistakes);
      return;
    }
    // Zostaw poprawny początek, resztę oddaj do puli.
    int ok = 0;
    while (ok < placed.length && pieces[placed[ok]] == pieces[ok]) {
      ok++;
    }
    setState(() {
      mistakes++;
      shake++;
      final back = placed.sublist(ok);
      placed.removeRange(ok, placed.length);
      back.shuffle();
      pool.addAll(back);
    });
    if (mistakes >= 2 && widget.task.hint.isNotEmpty) Speaker.speak(widget.task.hint);
  }

  Widget _tile(String text, double sc, {required bool placedTile, VoidCallback? onTap, bool green = false}) {
    final isLetter = text.length <= 2;
    return Material(
      color: green ? const Color(0xFF66BB6A) : (placedTile ? const Color(0xFFFFF59D) : Colors.white),
      elevation: 3,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minWidth: isLetter ? 50 * sc : 0, minHeight: 52 * sc),
          padding: EdgeInsets.symmetric(horizontal: isLetter ? 6 : 14, vertical: 8),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Text(
              text,
              style: TextStyle(
                fontSize: (isLetter ? 30 : 20) * sc,
                fontWeight: FontWeight.w800,
                color: green ? Colors.white : const Color(0xFF37474F),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.task;
    final sc = gradeScale(widget.grade);
    return Column(
      children: [
        Text(t.prompt,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26 * sc, fontWeight: FontWeight.w700, color: const Color(0xFF37474F))),
        Expanded(
          child: ScrollCenter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (t.visual.isNotEmpty) Text(t.visual, style: TextStyle(fontSize: 72 * sc)),
                const SizedBox(height: 16),
                Shake(
                  trigger: shake,
                  child: Container(
                    constraints: BoxConstraints(minHeight: 76 * sc),
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(150),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black12, width: 2),
                    ),
                    child: placed.isEmpty
                        ? Center(
                            child: Text('Dotykaj kafelki po kolei 👇',
                                style: TextStyle(fontSize: 16 * sc, color: Colors.black45)))
                        : Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (int k = 0; k < placed.length; k++)
                                _tile(pieces[placed[k]], sc,
                                    placedTile: true, green: solved, onTap: () => _unplace(k)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (int k = 0; k < pool.length; k++)
                      _tile(pieces[pool[k]], sc, placedTile: false, onTap: () => _place(k)),
                  ],
                ),
              ],
            ),
          ),
        ),
        FeedbackArea(
          solved: solved,
          praise: praise,
          explain: t.explain,
          hint: t.hint,
          showHint: mistakes >= 2,
          tryAgain: mistakes == 1,
          swipeHint: widget.swipeHint,
          scale: sc,
        ),
      ],
    );
  }
}
