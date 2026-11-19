import 'dart:math';

import '../models.dart';
import '../util.dart';

/// Temat z bazą pytań. Każda linia: "pytanie|poprawna|zła1|zła2(|zła3)|wyjaśnienie".
class BankTopic {
  final String id;
  final String name;
  final String subject;
  final int grade;
  final List<String> q;
  const BankTopic(this.id, this.name, this.subject, this.grade, this.q);
}

/// Pary do łączenia: "lewa=prawa".
class PairBank {
  final String id;
  final String name;
  final String subject;
  final int grade;
  final String prompt;
  final List<String> pairs;
  const PairBank(this.id, this.name, this.subject, this.grade, this.prompt, this.pairs);
}

/// Wydarzenia do ułożenia chronologicznie: "rok|opis" (rok p.n.e. ujemny).
class EventBank {
  final String id;
  final String name;
  final String subject;
  final int grade;
  final List<String> events;
  const EventBank(this.id, this.name, this.subject, this.grade, this.events);
}

Task bankChoice(BankTopic t, Random r) {
  final line = pick(r, t.q);
  final parts = line.split('|');
  final question = parts[0];
  final correct = parts[1];
  final explain = parts.length >= 4 ? parts.last : '';
  final wrong = parts.length >= 4 ? parts.sublist(2, parts.length - 1) : parts.sublist(2);
  final opts = shuffled(r, [correct, ...wrong.where((w) => w.isNotEmpty)]);
  return Task(
    skill: t.id,
    subject: t.subject,
    kind: TaskKind.choice,
    prompt: question,
    options: opts,
    answer: opts.indexOf(correct),
    hint: explain.isEmpty ? '' : 'Podpowiedź: wyeliminuj odpowiedzi, które na pewno nie pasują.',
    explain: explain,
  );
}

Task pairMatch(PairBank b, Random r, {int n = 4}) {
  final usedLeft = <String>{};
  final usedRight = <String>{};
  final chosen = <Pair>[];
  for (final line in shuffled(r, b.pairs)) {
    final i = line.indexOf('=');
    final a = line.substring(0, i).trim();
    final c = line.substring(i + 1).trim();
    if (usedLeft.contains(a) || usedRight.contains(c)) continue;
    usedLeft.add(a);
    usedRight.add(c);
    chosen.add(Pair(a, c));
    if (chosen.length >= n) break;
  }
  return Task(
    skill: b.id,
    subject: b.subject,
    kind: TaskKind.match,
    prompt: b.prompt,
    pairs: chosen,
    hint: 'Dotknij elementu po lewej, a potem pasującego po prawej.',
  );
}

String yearLabel(int y) => y < 0 ? '${-y} p.n.e.' : '$y';

Task eventOrder(EventBank b, Random r, {int n = 4}) {
  final parsed = b.events.map((e) {
    final i = e.indexOf('|');
    return MapEntry(int.parse(e.substring(0, i)), e.substring(i + 1));
  }).toList();
  final chosen = <MapEntry<int, String>>[];
  final years = <int>{};
  for (final e in shuffled(r, parsed)) {
    if (years.contains(e.key)) continue;
    years.add(e.key);
    chosen.add(e);
    if (chosen.length >= n) break;
  }
  chosen.sort((a, c) => a.key.compareTo(c.key));
  return Task(
    skill: b.id,
    subject: b.subject,
    kind: TaskKind.order,
    prompt: 'Ułóż wydarzenia od najwcześniejszego',
    pieces: chosen.map((e) => e.value).toList(),
    hint: 'Pomyśl, które wydarzenie było najdawniej. Pamiętaj: lata p.n.e. są wcześniej niż n.e.',
    explain: chosen.map((e) => '${yearLabel(e.key)} – ${e.value}').join('\n'),
  );
}
