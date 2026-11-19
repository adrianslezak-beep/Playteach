import 'dart:math';

import '../models.dart';
import '../util.dart';

Task choice(
  String skill,
  String subject,
  String prompt,
  List<String> options,
  String correct, {
  String? speak,
  String visual = '',
  List<String> items = const [],
  String hint = '',
  String explain = '',
}) {
  return Task(
    skill: skill,
    subject: subject,
    kind: TaskKind.choice,
    prompt: prompt,
    speak: speak,
    visual: visual,
    items: items,
    options: options,
    answer: options.indexOf(correct),
    hint: hint,
    explain: explain,
  );
}

/// Odpowiedzi liczbowe blisko poprawnej.
List<String> numOpts(Random r, int c, int n, {int spread = 3, int min = 0}) {
  final set = <int>{c};
  int guard = 0;
  while (set.length < n && guard < 300) {
    guard++;
    final v = c + r.nextInt(spread * 2 + 1) - spread;
    if (v >= min) set.add(v);
  }
  int k = 1;
  while (set.length < n) {
    set.add(c + spread + k);
    k++;
  }
  return shuffled(r, set.toList()).map((e) => '$e').toList();
}

/// Odpowiedzi z typowych pomyłek (np. o 1, o 10).
List<String> errOpts(Random r, int c, List<int> candidates, int n) {
  final list = <int>[c];
  for (final v in shuffled(r, candidates)) {
    if (list.length >= n) break;
    if (v >= 0 && !list.contains(v)) list.add(v);
  }
  int k = 1;
  while (list.length < n) {
    if (!list.contains(c + k)) list.add(c + k);
    k++;
  }
  return shuffled(r, list).map((e) => '$e').toList();
}
