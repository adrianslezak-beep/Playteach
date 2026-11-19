import 'dart:math';

import 'package:flutter/material.dart';

import '../models.dart';
import '../speaker.dart';
import 'common.dart';

/// Łączenie w pary: dotknij lewego, potem pasującego prawego.
class MatchCard extends StatefulWidget {
  final Task task;
  final int grade;
  final bool swipeHint;
  final void Function(int mistakes) onSolved;

  const MatchCard({super.key, required this.task, required this.grade, required this.onSolved, this.swipeHint = true});

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  late List<int> left;
  late List<int> right;
  final Set<int> matched = {};
  int? selected;
  int? wrongRight;
  int shake = 0;
  int mistakes = 0;
  bool solved = false;
  String praise = '';

  @override
  void initState() {
    super.initState();
    final r = Random();
    final n = widget.task.pairs.length;
    left = List<int>.generate(n, (i) => i)..shuffle(r);
    right = List<int>.generate(n, (i) => i)..shuffle(r);
  }

  void _tapLeft(int pairIdx) {
    if (solved || matched.contains(pairIdx)) return;
    setState(() => selected = pairIdx);
    final a = widget.task.pairs[pairIdx].a;
    if (!_isEmoji(a)) Speaker.speak(a);
  }

  void _tapRight(int pairIdx) {
    if (solved || matched.contains(pairIdx)) return;
    Speaker.speak(widget.task.pairs[pairIdx].b);
    if (selected == null) return;
    if (pairIdx == selected) {
      setState(() {
        matched.add(pairIdx);
        selected = null;
        wrongRight = null;
      });
      if (matched.length == widget.task.pairs.length) {
        setState(() {
          solved = true;
          praise = randomPraise();
        });
        Speaker.speak(praise);
        widget.onSolved(mistakes);
      }
    } else {
      setState(() {
        mistakes++;
        wrongRight = pairIdx;
        shake++;
      });
    }
  }

  bool _isEmoji(String s) => s.runes.isNotEmpty && s.runes.first > 0x2000;

  Widget _box(String text, double sc, {required Color color, required VoidCallback onTap, bool shakeIt = false}) {
    final emoji = _isEmoji(text);
    final w = Material(
      color: color,
      elevation: 3,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 64 * sc,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(text,
                style: TextStyle(
                    fontSize: (emoji ? 40 : 22) * sc, fontWeight: FontWeight.w800, color: const Color(0xFF37474F))),
          ),
        ),
      ),
    );
    return shakeIt ? Shake(trigger: shake, child: w) : w;
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.task;
    final sc = gradeScale(widget.grade);
    const green = Color(0xFFA5D6A7);
    return Column(
      children: [
        Text(t.prompt,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24 * sc, fontWeight: FontWeight.w700, color: const Color(0xFF37474F))),
        Expanded(
          child: ScrollCenter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      for (final i in left)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _box(t.pairs[i].a, sc,
                              color: matched.contains(i)
                                  ? green
                                  : (selected == i ? const Color(0xFFFFF59D) : Colors.white),
                              onTap: () => _tapLeft(i)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    children: [
                      for (final i in right)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _box(t.pairs[i].b, sc,
                              color: matched.contains(i) ? green : Colors.white,
                              onTap: () => _tapRight(i),
                              shakeIt: wrongRight == i),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        FeedbackArea(
          solved: solved,
          praise: praise,
          hint: t.hint,
          showHint: mistakes >= 2 || (selected == null && matched.isEmpty && mistakes == 0),
          tryAgain: mistakes == 1,
          swipeHint: widget.swipeHint,
          scale: sc,
        ),
      ],
    );
  }
}
