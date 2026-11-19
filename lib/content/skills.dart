import 'dart:math';

import '../models.dart';
import '../util.dart';
import 'math.dart';
import 'polish.dart';
import 'shapes.dart';

Task artTrace(Random r) {
  final s = pick(r, traceShapes);
  return Task(
    skill: 'art_trace',
    subject: 'art',
    kind: TaskKind.trace,
    prompt: 'Poprowadź palcem po kropkach i narysuj ${s.acc}',
    shape: s.id,
    hint: 'Jedź powoli palcem po kropkach, dookoła całego kształtu.',
  );
}

class SkillDef {
  final String id;
  final String name;
  final String subject;
  final int grade; // 0 = każda klasa
  final Task Function(Random r) gen;
  SkillDef(this.id, this.name, this.subject, this.grade, this.gen);
}

final List<SkillDef> allSkills = [
  // Klasa 1 – matematyka
  SkillDef('m1_count', 'Liczenie przedmiotów', 'math', 1, m1Count),
  SkillDef('m1_add', 'Dodawanie do 10/20', 'math', 1, m1Add),
  SkillDef('m1_sub', 'Odejmowanie do 10/20', 'math', 1, m1Sub),
  SkillDef('m1_compare', 'Porównywanie liczb', 'math', 1, m1Compare),
  SkillDef('m1_shapes', 'Figury geometryczne', 'math', 1, m1Shapes),
  SkillDef('m1_next', 'Kolejność liczb', 'math', 1, m1Next),
  // Klasa 1 – polski
  SkillDef('p1_letter', 'Pierwsza litera słowa', 'polish', 1, p1Letter),
  SkillDef('p1_syllables', 'Sylaby', 'polish', 1, p1Syllables),
  SkillDef('p1_build', 'Układanie słów z liter', 'polish', 1, p1Build),
  SkillDef('p1_match', 'Czytanie słów', 'polish', 1, p1Match),
  SkillDef('p1_vowel', 'Samogłoski', 'polish', 1, p1Vowel),
  // Klasa 2 – matematyka
  SkillDef('m2_add', 'Dodawanie do 100', 'math', 2, m2Add),
  SkillDef('m2_sub', 'Odejmowanie do 100', 'math', 2, m2Sub),
  SkillDef('m2_mul', 'Mnożenie (2–5)', 'math', 2, m2Mul),
  SkillDef('m2_tens', 'Dziesiątki i jedności', 'math', 2, m2Tens),
  SkillDef('m2_next', 'Ciągi liczb', 'math', 2, m2Next),
  SkillDef('m2_word', 'Zadania z treścią', 'math', 2, m2Word),
  // Klasa 2 – polski
  SkillDef('p2_ou', 'Pisownia ó / u', 'polish', 2, p2Ou),
  SkillDef('p2_rz', 'Pisownia rz / ż', 'polish', 2, p2Rz),
  SkillDef('p2_ch', 'Pisownia ch / h', 'polish', 2, p2Ch),
  SkillDef('p2_sentence', 'Układanie zdań', 'polish', 2, p2Sentence),
  SkillDef('p2_abc', 'Kolejność alfabetyczna', 'polish', 2, p2Abc),
  SkillDef('p2_build', 'Układanie słów z liter', 'polish', 2, p2Build),
  // Klasa 3 – matematyka
  SkillDef('m3_mul', 'Tabliczka mnożenia', 'math', 3, m3Mul),
  SkillDef('m3_div', 'Dzielenie', 'math', 3, m3Div),
  SkillDef('m3_missing', 'Brakujący czynnik', 'math', 3, m3Missing),
  SkillDef('m3_add', 'Dodawanie i odejmowanie do 1000', 'math', 3, m3Add),
  SkillDef('m3_word', 'Zadania z treścią', 'math', 3, m3Word),
  SkillDef('m3_units', 'Miary (długość, masa, czas)', 'math', 3, m3Units),
  SkillDef('m3_next', 'Ciągi liczb', 'math', 3, m3Next),
  // Klasa 3 – polski
  SkillDef('p3_pos', 'Części mowy', 'polish', 3, p3Pos),
  SkillDef('p3_opposites', 'Wyrazy przeciwstawne', 'polish', 3, p3Opposites),
  SkillDef('p3_plural', 'Liczba mnoga', 'polish', 3, p3Plural),
  SkillDef('p3_ortho', 'Ortografia', 'polish', 3, p3Ortho),
  SkillDef('p3_sentence', 'Układanie zdań', 'polish', 3, p3Sentence),
  SkillDef('p3_abc', 'Kolejność alfabetyczna', 'polish', 3, p3Abc),
  // Wszystkie klasy
  SkillDef('art_trace', 'Rysowanie po śladzie i kolorowanie', 'art', 0, artTrace),
];

List<SkillDef> skillsFor(int grade) => allSkills.where((s) => s.grade == grade || s.grade == 0).toList();

String skillName(String id) {
  for (final s in allSkills) {
    if (s.id == id) return s.name;
  }
  return id;
}

SkillDef? skillById(String id) {
  for (final s in allSkills) {
    if (s.id == id) return s;
  }
  return null;
}

/// Feed z adaptacją: słabiej opanowane umiejętności pojawiają się częściej.
class TaskGenerator {
  final Profile profile;
  final Random r;
  String? _last;

  TaskGenerator(this.profile, [Random? random]) : r = random ?? Random();

  double _weight(SkillDef s) {
    double w = s.subject == 'art' ? (profile.grade == 1 ? 1.0 : 0.6) : 1.0;
    final st = profile.skills[s.id];
    if (st != null && st.attempts >= 3) w *= 1 + (1 - st.rate) * 1.5;
    return w;
  }

  SkillDef _pick({String? subject, bool noArt = false}) {
    final all = skillsFor(profile.grade);
    var list = all
        .where((s) => s.id != _last && (subject == null || s.subject == subject) && !(noArt && s.subject == 'art'))
        .toList();
    if (list.isEmpty) list = all.where((s) => subject == null || s.subject == subject).toList();
    if (list.isEmpty) list = all;
    final total = list.fold<double>(0, (a, s) => a + _weight(s));
    var x = r.nextDouble() * total;
    for (final s in list) {
      x -= _weight(s);
      if (x <= 0) return s;
    }
    return list.last;
  }

  Task _gen(SkillDef s) {
    _last = s.id;
    return s.gen(r);
  }

  Task next() => _gen(_pick());

  Task nextOf(String subject) => _gen(_pick(subject: subject));

  List<Task> daily() => [
        nextOf('math'),
        nextOf('polish'),
        nextOf('math'),
        nextOf('polish'),
        _gen(_pick(noArt: true)),
        nextOf('art'),
      ];

  List<Task> weekly() => [
        nextOf('math'),
        nextOf('polish'),
        nextOf('math'),
        nextOf('polish'),
        nextOf('art'),
        nextOf('math'),
        nextOf('polish'),
        nextOf('math'),
        nextOf('polish'),
        _gen(_pick(noArt: true)),
        _gen(_pick(noArt: true)),
        nextOf('art'),
      ];
}
