import 'dart:math';

import '../models.dart';
import '../util.dart';
import 'bank.dart';
import 'english.dart';
import 'history.dart';
import 'math.dart';
import 'math48.dart';
import 'physchem.dart';
import 'polish.dart';
import 'polish48.dart';
import 'science.dart';
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

final List<SkillDef> allSkills = _buildSkills();

List<SkillDef> _buildSkills() {
  final out = <SkillDef>[
    // ───── Klasa 1 ─────
    SkillDef('m1_count', 'Liczenie przedmiotów', 'math', 1, m1Count),
    SkillDef('m1_add', 'Dodawanie do 10/20', 'math', 1, m1Add),
    SkillDef('m1_sub', 'Odejmowanie do 10/20', 'math', 1, m1Sub),
    SkillDef('m1_compare', 'Porównywanie liczb', 'math', 1, m1Compare),
    SkillDef('m1_shapes', 'Figury geometryczne', 'math', 1, m1Shapes),
    SkillDef('m1_next', 'Kolejność liczb', 'math', 1, m1Next),
    SkillDef('p1_letter', 'Pierwsza litera słowa', 'polish', 1, p1Letter),
    SkillDef('p1_syllables', 'Sylaby', 'polish', 1, p1Syllables),
    SkillDef('p1_build', 'Układanie słów z liter', 'polish', 1, p1Build),
    SkillDef('p1_match', 'Czytanie słów', 'polish', 1, p1Match),
    SkillDef('p1_vowel', 'Samogłoski', 'polish', 1, p1Vowel),
    // ───── Klasa 2 ─────
    SkillDef('m2_add', 'Dodawanie do 100', 'math', 2, m2Add),
    SkillDef('m2_sub', 'Odejmowanie do 100', 'math', 2, m2Sub),
    SkillDef('m2_mul', 'Mnożenie (2–5)', 'math', 2, m2Mul),
    SkillDef('m2_tens', 'Dziesiątki i jedności', 'math', 2, m2Tens),
    SkillDef('m2_next', 'Ciągi liczb', 'math', 2, m2Next),
    SkillDef('m2_word', 'Zadania z treścią', 'math', 2, m2Word),
    SkillDef('p2_ou', 'Pisownia ó / u', 'polish', 2, p2Ou),
    SkillDef('p2_rz', 'Pisownia rz / ż', 'polish', 2, p2Rz),
    SkillDef('p2_ch', 'Pisownia ch / h', 'polish', 2, p2Ch),
    SkillDef('p2_sentence', 'Układanie zdań', 'polish', 2, p2Sentence),
    SkillDef('p2_abc', 'Kolejność alfabetyczna', 'polish', 2, p2Abc),
    SkillDef('p2_build', 'Układanie słów z liter', 'polish', 2, p2Build),
    // ───── Klasa 3 ─────
    SkillDef('m3_mul', 'Tabliczka mnożenia', 'math', 3, m3Mul),
    SkillDef('m3_div', 'Dzielenie', 'math', 3, m3Div),
    SkillDef('m3_missing', 'Brakujący czynnik', 'math', 3, m3Missing),
    SkillDef('m3_add', 'Dodawanie i odejmowanie do 1000', 'math', 3, m3Add),
    SkillDef('m3_word', 'Zadania z treścią', 'math', 3, m3Word),
    SkillDef('m3_units', 'Miary (długość, masa, czas)', 'math', 3, m3Units),
    SkillDef('m3_next', 'Ciągi liczb', 'math', 3, m3Next),
    SkillDef('p3_pos', 'Części mowy', 'polish', 3, p3Pos),
    SkillDef('p3_opposites', 'Wyrazy przeciwstawne', 'polish', 3, p3Opposites),
    SkillDef('p3_plural', 'Liczba mnoga', 'polish', 3, p3Plural),
    SkillDef('p3_ortho', 'Ortografia', 'polish', 3, p3Ortho),
    SkillDef('p3_sentence', 'Układanie zdań', 'polish', 3, p3Sentence),
    SkillDef('p3_abc', 'Kolejność alfabetyczna', 'polish', 3, p3Abc),
    // Rysowanie – klasy 1–3
    for (int g = 1; g <= 3; g++) SkillDef('art_trace', 'Rysowanie po śladzie i kolorowanie', 'art', g, artTrace),
    // ───── Matematyka 4–8 ─────
    SkillDef('m4_add', 'Dodawanie i odejmowanie pisemne', 'math', 4, m4Add),
    SkillDef('m4_mul', 'Mnożenie pisemne', 'math', 4, m4Mul),
    SkillDef('m4_div', 'Dzielenie z resztą', 'math', 4, m4Div),
    SkillDef('m4_order', 'Kolejność działań', 'math', 4, m4Order),
    SkillDef('m4_roman', 'System rzymski', 'math', 4, m4Roman),
    SkillDef('m4_frac', 'Części liczby (ułamki)', 'math', 4, m4Frac),
    SkillDef('m4_time', 'Obliczenia zegarowe', 'math', 4, m4Time),
    SkillDef('m4_perimeter', 'Obwody figur', 'math', 4, m4Perimeter),
    SkillDef('m4_word', 'Zadania z treścią', 'math', 4, m4Word),
    SkillDef('m5_frac_add', 'Dodawanie i odejmowanie ułamków', 'math', 5, m5FracAdd),
    SkillDef('m5_frac_cmp', 'Porównywanie ułamków', 'math', 5, m5FracCmp),
    SkillDef('m5_reduce', 'Skracanie ułamków', 'math', 5, m5Reduce),
    SkillDef('m5_dec', 'Ułamki dziesiętne', 'math', 5, m5Dec),
    SkillDef('m5_divisible', 'Podzielność liczb', 'math', 5, m5Divisible),
    SkillDef('m5_area', 'Pola figur', 'math', 5, m5Area),
    SkillDef('m5_powers', 'Kwadrat i sześcian liczby', 'math', 5, m5Powers),
    SkillDef('m5_angles', 'Kąty', 'math', 5, m5Angles),
    SkillDef('m6_frac_muldiv', 'Mnożenie i dzielenie ułamków', 'math', 6, m6FracMul),
    SkillDef('m6_neg', 'Liczby ujemne', 'math', 6, m6Neg),
    SkillDef('m6_dec_mul', 'Mnożenie ułamków dziesiętnych', 'math', 6, m6DecMul),
    SkillDef('m6_expr', 'Wyrażenia algebraiczne', 'math', 6, m6Expr),
    SkillDef('m6_volume', 'Objętość prostopadłościanu', 'math', 6, m6Volume),
    SkillDef('m6_mean', 'Średnia arytmetyczna', 'math', 6, m6Mean),
    SkillDef('m7_percent', 'Procenty', 'math', 7, m7Percent),
    SkillDef('m7_powers', 'Potęgi', 'math', 7, m7Powers),
    SkillDef('m7_roots', 'Pierwiastki', 'math', 7, m7Roots),
    SkillDef('m7_equation', 'Równania', 'math', 7, m7Equation),
    SkillDef('m7_simplify', 'Wyrażenia algebraiczne', 'math', 7, m7Simplify),
    SkillDef('m7_proportion', 'Proporcje', 'math', 7, m7Proportion),
    SkillDef('m8_pythagoras', 'Twierdzenie Pitagorasa', 'math', 8, m8Pythagoras),
    SkillDef('m8_circle', 'Koło i okrąg', 'math', 8, m8Circle),
    SkillDef('m8_probability', 'Prawdopodobieństwo', 'math', 8, m8Probability),
    SkillDef('m8_irrational', 'Pierwiastki w geometrii', 'math', 8, m8Square),
    SkillDef('m8_solids', 'Bryły – objętość', 'math', 8, m8Prism),
    SkillDef('m7_percent', 'Procenty', 'math', 8, m7Percent),
    SkillDef('m7_equation', 'Równania', 'math', 8, m7Equation),
    // ───── Fizyka i chemia – zadania liczbowe ─────
    SkillDef('f7_calc', 'Obliczenia: ruch, gęstość, ciężar', 'physics', 7, (r) => r.nextBool() ? f7Speed(r) : f7Density(r)),
    SkillDef('f8_calc', 'Obliczenia: prawo Ohma i moc', 'physics', 8, f8Ohm),
    SkillDef('c7_calc', 'Masa cząsteczkowa', 'chemistry', 7, c7Mass),
    SkillDef('c7_calc', 'Masa cząsteczkowa', 'chemistry', 8, c7Mass),
    // ───── Polski 4–8 ─────
    for (int g = 4; g <= 8; g++) SkillDef('p4_nie', 'Pisownia „nie”', 'polish', g, nieTask),
    // ───── Angielski 4–8 ─────
    for (int g = 4; g <= 8; g++)
      SkillDef('e${g}_vocab', 'Słówka', 'english', g, (r) => r.nextBool() ? vocabMatch(g)(r) : vocabChoice(g)(r)),
    SkillDef('e4_aan', 'A / an', 'english', 4, aAn),
    SkillDef('e4_plural', 'Liczba mnoga rzeczowników', 'english', 4, plurals),
    for (int g = 5; g <= 8; g++) SkillDef('e${g}_comparatives', 'Stopniowanie przymiotników', 'english', g, comparatives(g)),
    for (int g = 6; g <= 8; g++) SkillDef('e${g}_irregular', 'Czasowniki nieregularne', 'english', g, irregularTask(g)),
  ];
  for (final t in [...polishBanks, ...englishGrammar, ...historyBanks, ...civicsBanks, ...scienceBanks, ...physchemBanks]) {
    out.add(SkillDef(t.id, t.name, t.subject, t.grade, (r) => bankChoice(t, r)));
  }
  for (final b in [...polishPairs, ...sciencePairs, ...physchemPairs]) {
    out.add(SkillDef(b.id, b.name, b.subject, b.grade, (r) => pairMatch(b, r)));
  }
  for (final b in historyEvents) {
    out.add(SkillDef(b.id, b.name, b.subject, b.grade, (r) => eventOrder(b, r)));
  }
  return out;
}

/// Umiejętności dla klasy. Od klasy 5 dochodzi powtórka z wcześniejszych klas (z mniejszą wagą).
List<SkillDef> skillsFor(int grade) => allSkills
    .where((s) =>
        s.grade == grade || (grade >= 5 && s.grade >= 4 && s.grade < grade && s.subject != 'nature'))
    .toList();

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

/// Feed z adaptacją: najpierw losujemy przedmiot, potem umiejętność.
/// Słabiej opanowane umiejętności pojawiają się częściej, a te same pytania nie wracają od razu.
class TaskGenerator {
  final Profile profile;
  final Random r;
  String? _last;
  String? _lastSubject;
  final List<String> _recent = [];

  TaskGenerator(this.profile, [Random? random]) : r = random ?? Random();

  int get grade => profile.grade;

  double _subjectWeight(String s) {
    if (grade <= 3) {
      if (s == 'art') return grade == 1 ? 0.25 : 0.15;
      return 1.0;
    }
    switch (s) {
      case 'math':
        return 1.4;
      case 'polish':
        return 1.2;
      case 'english':
        return 1.0;
      default:
        return 0.9;
    }
  }

  double _skillWeight(SkillDef s) {
    double w = s.grade == grade ? 1.0 : 0.35;
    final st = profile.skills[s.id];
    if (st != null && st.attempts >= 3) w *= 1 + (1 - st.rate) * 1.5;
    return w;
  }

  T _weighted<T>(List<T> items, double Function(T) weight) {
    final total = items.fold<double>(0, (a, e) => a + weight(e));
    var x = r.nextDouble() * total;
    for (final e in items) {
      x -= weight(e);
      if (x <= 0) return e;
    }
    return items.last;
  }

  SkillDef _pick({String? subject, bool noArt = false}) {
    final all = skillsFor(grade);
    String subj;
    if (subject != null && all.any((s) => s.subject == subject)) {
      subj = subject;
    } else {
      var subs = all.map((s) => s.subject).toSet().where((s) => !(noArt && s == 'art')).toList();
      if (subs.length > 2 && _lastSubject != null) {
        final without = subs.where((s) => s != _lastSubject).toList();
        if (without.isNotEmpty && r.nextInt(3) > 0) subs = without;
      }
      subj = _weighted(subs, _subjectWeight);
    }
    var list = all.where((s) => s.subject == subj && s.id != _last).toList();
    if (list.isEmpty) list = all.where((s) => s.subject == subj).toList();
    return _weighted(list, _skillWeight);
  }

  String _key(Task t) => '${t.skill}|${t.prompt}|${t.visual}|${t.options.join(',')}';

  Task _gen(SkillDef s) {
    _last = s.id;
    _lastSubject = s.subject;
    Task t = s.gen(r);
    for (int i = 0; i < 6 && _recent.contains(_key(t)); i++) {
      t = s.gen(r);
    }
    _recent.add(_key(t));
    if (_recent.length > 60) _recent.removeAt(0);
    return t;
  }

  Task next() => _gen(_pick());

  Task nextOf(String subject) => _gen(_pick(subject: subject));

  Task _any() => _gen(_pick(noArt: true));

  List<Task> daily() {
    if (grade <= 3) {
      return [nextOf('math'), nextOf('polish'), nextOf('math'), nextOf('polish'), _any(), nextOf('art')];
    }
    return [nextOf('math'), nextOf('polish'), _any(), nextOf('math'), _any(), _any()];
  }

  List<Task> weekly() {
    if (grade <= 3) {
      return [
        nextOf('math'), nextOf('polish'), nextOf('math'), nextOf('polish'), nextOf('art'), nextOf('math'),
        nextOf('polish'), nextOf('math'), nextOf('polish'), _any(), _any(), nextOf('art'),
      ];
    }
    final subs = skillsFor(grade).where((s) => s.grade == grade).map((s) => s.subject).toSet().toList()..shuffle(r);
    final out = <Task>[nextOf('math'), nextOf('polish')];
    for (final s in subs) {
      if (out.length >= 10) break;
      if (s != 'math' && s != 'polish') out.add(nextOf(s));
    }
    while (out.length < 12) {
      out.add(_any());
    }
    return out;
  }
}
