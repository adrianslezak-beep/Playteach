import 'dart:math';

import '../models.dart';
import '../util.dart';
import 'common.dart';
import 'words.dart';

const _m = 'math';

// ───────────────────────── KLASA 1 ─────────────────────────

Task m1Count(Random r) {
  final n = 1 + r.nextInt(10);
  final e = pick(r, countItems);
  return choice('m1_count', _m, 'Ile tu jest?', numOpts(r, n, 3, spread: 2, min: 1), '$n',
      speak: 'Policz i zaznacz, ile tu jest.',
      items: List.filled(n, e),
      hint: 'Dotykaj palcem każdego po kolei i licz na głos.',
      explain: 'Jest ich $n.');
}

Task m1Add(Random r) {
  final max = r.nextInt(10) < 3 ? 20 : 10;
  final c = 1 + r.nextInt(max);
  final a = r.nextInt(c + 1);
  final b = c - a;
  final e = pick(r, countItems);
  final items = (c <= 10 && a > 0 && b > 0)
      ? <String>[...List.filled(a, e), '➕', ...List.filled(b, e)]
      : <String>[];
  return choice('m1_add', _m, 'Ile to jest?', numOpts(r, c, 3, spread: 2), '$c',
      speak: 'Ile to jest $a dodać $b?',
      visual: '$a + $b = ?',
      items: items,
      hint: 'Zacznij od $a i doliczaj jeszcze $b.',
      explain: '$a + $b = $c');
}

Task m1Sub(Random r) {
  final max = r.nextInt(10) < 3 ? 20 : 10;
  final a = 1 + r.nextInt(max);
  final b = r.nextInt(a + 1);
  final c = a - b;
  return choice('m1_sub', _m, 'Ile to jest?', numOpts(r, c, 3, spread: 2), '$c',
      speak: 'Ile to jest $a odjąć $b?',
      visual: '$a − $b = ?',
      hint: 'Zacznij od $a i cofnij się o $b.',
      explain: '$a − $b = $c');
}

Task m1Compare(Random r) {
  final a = r.nextInt(21);
  final b = r.nextInt(10) < 2 ? a : r.nextInt(21);
  final c = a > b ? '>' : (a < b ? '<' : '=');
  return choice('m1_compare', _m, 'Który znak pasuje?', const ['<', '=', '>'], c,
      speak: 'Porównaj liczby $a i $b. Który znak pasuje?',
      visual: '$a   ?   $b',
      hint: 'Dzióbek 🐊 zawsze otwiera się do większej liczby.',
      explain: '$a $c $b');
}

const Map<String, String> shapeNames = {
  'circle': 'koło',
  'square': 'kwadrat',
  'triangle': 'trójkąt',
  'rect': 'prostokąt',
};

Task m1Shapes(Random r) {
  final keys = shapeNames.keys.toList();
  final correct = pick(r, keys);
  final others = shuffled(r, keys.where((k) => k != correct).toList()).take(2);
  final opts = shuffled(r, [correct, ...others]).map((k) => 'shape:$k').toList();
  final name = shapeNames[correct]!;
  return choice('m1_shapes', _m, 'Gdzie jest $name?', opts, 'shape:$correct',
      hint: name == 'trójkąt'
          ? 'Trójkąt ma 3 boki i 3 rogi.'
          : name == 'kwadrat'
              ? 'Kwadrat ma 4 równe boki.'
              : name == 'koło'
                  ? 'Koło jest okrągłe jak piłka.'
                  : 'Prostokąt ma 4 boki – dwa dłuższe i dwa krótsze.');
}

Task m1Next(Random r) {
  final up = r.nextBool();
  late List<int> seq;
  late int c;
  if (up) {
    final s = r.nextInt(15);
    seq = [s, s + 1, s + 2];
    c = s + 3;
  } else {
    final s = 4 + r.nextInt(16);
    seq = [s, s - 1, s - 2];
    c = s - 3;
  }
  return choice('m1_next', _m, 'Jaka liczba będzie następna?', numOpts(r, c, 3, spread: 2), '$c',
      speak: 'Jaka liczba będzie następna? ${seq.join(', ')}',
      visual: '${seq.join(', ')}, ?',
      hint: up ? 'Liczby rosną o 1.' : 'Liczby maleją o 1.',
      explain: '${seq.join(', ')}, $c');
}

// ───────────────────────── KLASA 2 ─────────────────────────

Task m2Add(Random r) {
  final a = 10 + r.nextInt(80);
  final b = 1 + r.nextInt(100 - a);
  final c = a + b;
  return choice('m2_add', _m, 'Oblicz', errOpts(r, c, [c + 1, c - 1, c + 10, c - 10], 4), '$c',
      speak: 'Ile to jest $a dodać $b?',
      visual: '$a + $b = ?',
      hint: 'Najpierw dodaj dziesiątki, potem jedności.',
      explain: '$a + $b = $c');
}

Task m2Sub(Random r) {
  final a = 20 + r.nextInt(81);
  final b = 1 + r.nextInt(a - 1);
  final c = a - b;
  return choice('m2_sub', _m, 'Oblicz', errOpts(r, c, [c + 1, c - 1, c + 10, c - 10], 4), '$c',
      speak: 'Ile to jest $a odjąć $b?',
      visual: '$a − $b = ?',
      hint: 'Najpierw odejmij dziesiątki, potem jedności.',
      explain: '$a − $b = $c');
}

Task m2Mul(Random r) {
  final a = 2 + r.nextInt(4);
  final b = 1 + r.nextInt(10);
  final c = a * b;
  return choice('m2_mul', _m, 'Oblicz',
      errOpts(r, c, [a * (b + 1), a * (b - 1), c + 1, c - 1, (a + 1) * b], 4), '$c',
      speak: 'Ile to jest $a razy $b?',
      visual: '$a × $b = ?',
      hint: '$a × $b to $b dodane $a razy.',
      explain: '$a × $b = $c');
}

Task m2Tens(Random r) {
  final n = 11 + r.nextInt(89);
  final tens = r.nextBool();
  final c = tens ? n ~/ 10 : n % 10;
  final what = tens ? 'dziesiątek' : 'jedności';
  return choice('m2_tens', _m, 'Ile $what ma liczba $n?', numOpts(r, c, 4, spread: 3), '$c',
      visual: '$n',
      hint: 'Dziesiątki to pierwsza cyfra, jedności – ostatnia.',
      explain: '$n = ${n ~/ 10} dziesiątek i ${n % 10} jedności');
}

Task m2Next(Random r) {
  final step = pick(r, const [2, 3, 5, 10]);
  final s = step * r.nextInt(6);
  final seq = [s, s + step, s + 2 * step];
  final c = s + 3 * step;
  return choice('m2_next', _m, 'Jaka liczba będzie następna?',
      errOpts(r, c, [c + 1, c - 1, c + step, c + 2], 4), '$c',
      speak: 'Jaka liczba będzie następna? ${seq.join(', ')}',
      visual: '${seq.join(', ')}, ?',
      hint: 'Sprawdź, o ile rosną liczby.',
      explain: 'Liczby rosną o $step: ${seq.join(', ')}, $c');
}

Task m2Word(Random r) {
  switch (r.nextInt(4)) {
    case 0:
      final a = 10 + r.nextInt(51);
      final b = 5 + r.nextInt(26);
      final c = a + b;
      return choice('m2_word', _m,
          'Ola miała $a ${plural(a, 'cukierek', 'cukierki', 'cukierków')}. Dostała jeszcze $b. Ile ma ich teraz?',
          errOpts(r, c, [c + 1, c - 1, c + 10, c - 10, a - b], 4), '$c',
          visual: '🍬', explain: '$a + $b = $c');
    case 1:
      final a = 20 + r.nextInt(81);
      final b = 5 + r.nextInt(a - 10);
      final c = a - b;
      return choice('m2_word', _m, 'Tata miał $a zł. Wydał $b zł na zakupy. Ile złotych mu zostało?',
          errOpts(r, c, [c + 1, c - 1, c + 10, c - 10, a + b], 4), '$c',
          visual: '💰', explain: '$a − $b = $c');
    case 2:
      final a = 30 + r.nextInt(71);
      final b = 5 + r.nextInt(a - 10);
      final c = a - b;
      return choice('m2_word', _m,
          'Książka ma $a ${plural(a, 'stronę', 'strony', 'stron')}. Kasia przeczytała już $b. Ile stron zostało jej do przeczytania?',
          errOpts(r, c, [c + 1, c - 1, c + 10, c - 10, a + b], 4), '$c',
          visual: '📖', explain: '$a − $b = $c');
    default:
      final a = 8 + r.nextInt(8);
      final b = 8 + r.nextInt(8);
      final c = a + b;
      return choice('m2_word', _m,
          'W klasie jest $a ${plural(a, 'dziewczynka', 'dziewczynki', 'dziewczynek')} i $b ${plural(b, 'chłopiec', 'chłopców', 'chłopców')}. Ile dzieci jest w klasie?',
          errOpts(r, c, [c + 1, c - 1, c + 10, c - 10], 4), '$c',
          visual: '👧👦', explain: '$a + $b = $c');
  }
}

// ───────────────────────── KLASA 3 ─────────────────────────

Task m3Mul(Random r) {
  final a = 2 + r.nextInt(9);
  final b = 2 + r.nextInt(9);
  final c = a * b;
  return choice('m3_mul', _m, 'Oblicz',
      errOpts(r, c, [a * (b + 1), a * (b - 1), (a + 1) * b, (a - 1) * b, c + 1], 4), '$c',
      speak: 'Ile to jest $a razy $b?',
      visual: '$a × $b = ?',
      hint: 'Możesz policzyć $b + $b + … ($a razy).',
      explain: '$a × $b = $c');
}

Task m3Div(Random r) {
  final a = 2 + r.nextInt(9);
  final b = 2 + r.nextInt(9);
  final c = a * b;
  return choice('m3_div', _m, 'Oblicz', errOpts(r, b, [b + 1, b - 1, b + 2, a], 4), '$b',
      speak: 'Ile to jest $c podzielić przez $a?',
      visual: '$c : $a = ?',
      hint: 'Pomyśl: $a razy ile daje $c?',
      explain: '$c : $a = $b, bo $a × $b = $c');
}

Task m3Missing(Random r) {
  final a = 2 + r.nextInt(9);
  final b = 2 + r.nextInt(9);
  final c = a * b;
  return choice('m3_missing', _m, 'Jaka liczba się ukryła?', errOpts(r, b, [b + 1, b - 1, b + 2, b - 2], 4), '$b',
      speak: '$a razy ile daje $c?',
      visual: '$a × ? = $c',
      hint: 'Podziel $c przez $a.',
      explain: '$a × $b = $c');
}

Task m3Add(Random r) {
  final add = r.nextBool();
  late int a, b, c;
  if (add) {
    a = 100 + r.nextInt(800);
    final maxB = 999 - a;
    b = 10 + r.nextInt(max(1, maxB - 10));
    c = a + b;
  } else {
    a = 200 + r.nextInt(800);
    b = 10 + r.nextInt(a - 100);
    c = a - b;
  }
  final op = add ? '+' : '−';
  return choice('m3_add', _m, 'Oblicz',
      errOpts(r, c, [c + 1, c - 1, c + 10, c - 10, c + 100, c - 100], 4), '$c',
      speak: 'Ile to jest $a ${add ? 'dodać' : 'odjąć'} $b?',
      visual: '$a $op $b = ?',
      hint: 'Licz po kolei: setki, dziesiątki, jedności.',
      explain: '$a $op $b = $c');
}

Task m3Word(Random r) {
  switch (r.nextInt(4)) {
    case 0:
      final a = 2 + r.nextInt(8);
      final b = 2 + r.nextInt(9);
      final c = a * b;
      return choice('m3_word', _m,
          'W $a pudełkach jest po $b ${plural(b, 'kredka', 'kredki', 'kredek')}. Ile kredek jest razem?',
          errOpts(r, c, [a + b, c + a, c - b, c + 1], 4), '$c',
          visual: '🖍️', explain: '$a × $b = $c');
    case 1:
      final a = 2 + r.nextInt(5);
      final b = 2 + r.nextInt(8);
      final c = a * b;
      return choice('m3_word', _m,
          'Mama ma $c ${plural(c, 'cukierek', 'cukierki', 'cukierków')}. Dzieli je po równo między $a ${plural(a, 'osobę', 'osoby', 'osób')}. Ile cukierków dostanie każda osoba?',
          errOpts(r, b, [b + 1, b - 1, c - a, b + 2], 4), '$b',
          visual: '🍬', explain: '$c : $a = $b');
    case 2:
      final a = 2 + r.nextInt(5);
      final b = 8 + r.nextInt(13);
      final c = a * b;
      return choice('m3_word', _m,
          'Bilet do kina kosztuje $b zł. Ile trzeba zapłacić za $a ${plural(a, 'bilet', 'bilety', 'biletów')}?',
          errOpts(r, c, [a + b, c + b, c - b, c + 10], 4), '$c',
          visual: '🎟️', explain: '$a × $b zł = $c zł');
    default:
      final a = 100 + r.nextInt(400);
      final b = 20 + r.nextInt(a - 50);
      final c = a - b;
      return choice('m3_word', _m,
          'W sklepie było $a ${plural(a, 'jabłko', 'jabłka', 'jabłek')}. Sprzedano $b. Ile jabłek zostało?',
          errOpts(r, c, [c + 10, c - 10, c + 100, a + b], 4), '$c',
          visual: '🍎', explain: '$a − $b = $c');
  }
}

const List<List<String>> _units = [
  ['Ile centymetrów ma 1 metr?', '100'],
  ['Ile minut ma 1 godzina?', '60'],
  ['Ile dni ma tydzień?', '7'],
  ['Ile miesięcy ma rok?', '12'],
  ['Ile gramów ma 1 kilogram?', '1000'],
  ['Ile godzin ma doba?', '24'],
  ['Ile milimetrów ma 1 centymetr?', '10'],
  ['Ile groszy ma 1 złoty?', '100'],
  ['Ile centymetrów to 2 metry?', '200'],
  ['Ile gramów to 3 kilogramy?', '3000'],
  ['Ile minut to 2 godziny?', '120'],
  ['Ile minut to pół godziny?', '30'],
  ['Ile sekund ma 1 minuta?', '60'],
  ['Ile dni ma 2 tygodnie?', '14'],
];

Task m3Units(Random r) {
  final u = pick(r, _units);
  final c = int.parse(u[1]);
  final pool = _units.map((e) => int.parse(e[1])).where((v) => v != c).toSet().toList();
  final opts = shuffled(r, [c, ...pickN(r, pool, 3)]).map((e) => '$e').toList();
  return choice('m3_units', _m, u[0], opts, u[1],
      visual: '📏', hint: 'Przypomnij sobie miary: metr, kilogram, godzina…', explain: u[0].replaceAll('?', ': ${u[1]}'));
}

Task m3Next(Random r) {
  final step = pick(r, const [3, 4, 6, 7, 8, 9, 25, 50, 100]);
  final s = step * r.nextInt(5);
  final seq = [s, s + step, s + 2 * step];
  final c = s + 3 * step;
  return choice('m3_next', _m, 'Jaka liczba będzie następna?',
      errOpts(r, c, [c + 1, c - 1, c + step, c + 10], 4), '$c',
      speak: 'Jaka liczba będzie następna? ${seq.join(', ')}',
      visual: '${seq.join(', ')}, ?',
      hint: 'Sprawdź, o ile rosną liczby.',
      explain: 'Liczby rosną o $step');
}
