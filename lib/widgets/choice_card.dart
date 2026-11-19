import 'package:flutter/material.dart';

import '../models.dart';
import '../speaker.dart';
import 'common.dart';

class ChoiceCard extends StatefulWidget {
  final Task task;
  final int grade;
  final bool swipeHint;
  final void Function(int mistakes) onSolved;

  const ChoiceCard({super.key, required this.task, required this.grade, required this.onSolved, this.swipeHint = true});

  @override
  State<ChoiceCard> createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  final Set<int> wrong = {};
  bool solved = false;
  int mistakes = 0;
  int shake = 0;
  int lastWrong = -1;
  String praise = '';

  void _tap(int i) {
    if (solved || wrong.contains(i)) return;
    if (i == widget.task.answer) {
      setState(() {
        solved = true;
        praise = randomPraise();
      });
      Speaker.speak(praise);
      widget.onSolved(mistakes);
    } else {
      setState(() {
        mistakes++;
        wrong.add(i);
        lastWrong = i;
        shake++;
      });
      if (mistakes >= 2 && widget.task.hint.isNotEmpty) Speaker.speak(widget.task.hint);
    }
  }

  Widget _visual(double sc) {
    final t = widget.task;
    final children = <Widget>[];
    if (t.visual.isNotEmpty) {
      final long = t.visual.length > 14;
      children.add(Text(
        t.visual,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: (long ? 30 : 46) * sc, fontWeight: FontWeight.w800, color: const Color(0xFF263238)),
      ));
    }
    if (t.items.isNotEmpty) {
      final n = t.items.length;
      final size = (n > 12 ? 30.0 : (n > 6 ? 38.0 : 48.0)) * sc;
      children.add(Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: t.items.map((e) => Text(e, style: TextStyle(fontSize: size))).toList(),
        ),
      ));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  Widget _option(int i, double sc, bool short) {
    final t = widget.task;
    final text = t.options[i];
    final isWrong = wrong.contains(i);
    final isRight = solved && i == t.answer;
    final bg = isRight ? const Color(0xFF66BB6A) : (isWrong ? const Color(0xFFE0E0E0) : Colors.white);
    Widget label;
    if (text.startsWith('shape:')) {
      label = ShapeIcon(kind: text.substring(6), size: 54 * sc, color: isWrong ? Colors.black26 : const Color(0xFF5C6BC0));
    } else {
      label = Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: (short ? 34 : 22) * sc,
          fontWeight: FontWeight.w800,
          color: isWrong ? Colors.black26 : (isRight ? Colors.white : const Color(0xFF37474F)),
        ),
      );
    }
    final btn = Material(
      color: bg,
      elevation: isWrong ? 0 : 3,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _tap(i),
        child: Container(
          width: short ? 92 * sc : double.infinity,
          height: short ? 92 * sc : 62 * sc,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: label,
        ),
      ),
    );
    return i == lastWrong ? Shake(trigger: shake, child: btn) : btn;
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.task;
    final sc = gradeScale(widget.grade);
    final short = t.options.every((o) => o.length <= 4);
    final longPrompt = t.prompt.length > 60;
    return Column(
      children: [
        Text(
          t.prompt,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: (longPrompt ? 21 : 26) * sc, fontWeight: FontWeight.w700, color: const Color(0xFF37474F)),
        ),
        Expanded(child: ScrollCenter(child: _visual(sc))),
        if (short)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 14,
            children: [for (int i = 0; i < t.options.length; i++) _option(i, sc, true)],
          )
        else
          Column(
            children: [
              for (int i = 0; i < t.options.length; i++)
                Padding(padding: const EdgeInsets.only(bottom: 10), child: _option(i, sc, false)),
            ],
          ),
        const SizedBox(height: 12),
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
