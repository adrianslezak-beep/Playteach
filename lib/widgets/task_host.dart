import 'package:flutter/material.dart';

import '../models.dart';
import '../speaker.dart';
import 'choice_card.dart';
import 'common.dart';
import 'match_card.dart';
import 'order_card.dart';
import 'trace_card.dart';

/// Pełnoekranowa karta zadania (tło, nagłówek, treść).
class TaskHost extends StatefulWidget {
  final Task task;
  final int grade;
  final int index;
  final bool done;
  final bool feedMode;
  final void Function(int mistakes) onSolved;
  final VoidCallback? onSkip;

  const TaskHost({
    super.key,
    required this.task,
    required this.grade,
    required this.index,
    required this.onSolved,
    this.done = false,
    this.feedMode = true,
    this.onSkip,
  });

  @override
  State<TaskHost> createState() => _TaskHostState();
}

class _TaskHostState extends State<TaskHost> {
  late final bool wasDone = widget.done;

  Widget _body() {
    final t = widget.task;
    if (wasDone) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('✅', style: TextStyle(fontSize: 90)),
            SizedBox(height: 12),
            Text('Zrobione!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            SizedBox(height: 6),
            Text('Przesuń w górę po następne ⬆', style: TextStyle(color: Colors.black54)),
          ],
        ),
      );
    }
    switch (t.kind) {
      case TaskKind.choice:
        return ChoiceCard(task: t, grade: widget.grade, onSolved: widget.onSolved, swipeHint: widget.feedMode);
      case TaskKind.order:
        return OrderCard(task: t, grade: widget.grade, onSolved: widget.onSolved, swipeHint: widget.feedMode);
      case TaskKind.match:
        return MatchCard(task: t, grade: widget.grade, onSolved: widget.onSolved, swipeHint: widget.feedMode);
      case TaskKind.trace:
        return TraceCard(
            task: t, grade: widget.grade, onSolved: widget.onSolved, onSkip: widget.onSkip, swipeHint: widget.feedMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final g = cardGradients[widget.index % cardGradients.length];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: g),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, widget.feedMode ? 64 : 56, 16, 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                children: [
                  Row(
                    children: [
                      SubjectChip(subject: widget.task.subject),
                      const Spacer(),
                      IconButton.filledTonal(
                        tooltip: 'Przeczytaj',
                        onPressed: () => Speaker.speak(widget.task.speak),
                        icon: const Icon(Icons.volume_up_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(child: _body()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
