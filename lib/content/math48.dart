import 'dart:math';

import '../models.dart';
import '../util.dart';
import 'common.dart';

const _m = 'math';

// ───────────────────────── POMOCNICZE ─────────────────────────

int gcd(int a, int b) {
  a = a.abs();
  b = b.abs();
  while (b != 0) {
    final t = a % b;
    a = b;
    b = t;
  }
  return a == 0 ? 1 : a;
}

/// Liczba ze znakiem minus typograficznym.
String sn(int v) => v < 0 ? '−${-v}' : '$v';

/// Liczba w nawiasie, gdy ujemna.
String sp(int v) => v < 0 ? '(${sn(v)})' : '$v';

/// Ułamek skrócony: "3/4" albo liczba całkowita.
String fs(int n, int d) {
  if (d < 0) {
    n = -n;
    d = -d;
  }
  final g = gcd(n, d);
  n ~/= g;
  d ~/= g;
  if (d == 1) return sn(n);
  return '${sn(n)}/$d';
}

/// Liczba dziesiętna z setnych części, z polskim przecinkiem.
String dec(int h) {
  final neg = h < 0;
  final a = h.abs();
  final i = a ~/ 100;
  final f = a % 100;
  String s;
  if (f == 0) {
    s = '$i';
  } else if (f % 10 == 0) {
    s = '$i,${f ~/ 10}';
  } else {
    s = '$i,${two(f)}';
  }
  return neg ? '−$s' : s;
}

List<String> fracOpts(Random r, List<int> c, List<List<int>> cands, int n) {
  bool same(List<int> x, List<int> y) => x[0] * y[1] == y[0] * x[1];
  final out = <List<int>>[c];
  for (final f in shuffled(r, cands)) {
    if (out.length >= n) break;
    if (f[1] <= 0 || f[0] < 0) continue;
    if (out.any((o) => same(o, f))) continue;
    out.add(f);
  }
  int k = 1;
  while (out.length < n) {
    final f = [c[0] + k, c[1]];
    if (!out.any((o) => same(o, f))) out.add(f);
    k++;
  }
  return shuffled(r, out).map((f) => fs(f[0], f[1])).toList();
}

List<String> decOpts(Random r, int c, List<int> cands, int n) {
  final list = <int>[c];
  for (final v in shuffled(r, cands)) {
    if (list.length >= n) break;
    if (!list.contains(v)) list.add(v);
  }
  int k = 1;
  while (list.length < n) {
    if (!list.contains(c + 10 * k)) list.add(c + 10 * k);
    k++;
  }
  return shuffled(r, list).map(dec).toList();
}

List<String> intOpts(Random r, int c, List<int> cands, int n) {
  final list = <int>[c];
  for (final v in shuffled(r, cands)) {
    if (list.length >= n) break;
    if (!list.contains(v)) list.add(v);
  }
  int k = 1;
  while (list.length < n) {
    if (!list.contains(c + k)) list.add(c + k);
    k++;
  }
  return shuffled(r, list).map(sn).toList();
}

String roman(int n) {
  const v = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
  const s = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I'];
  final b = StringBuffer();
  for (int i = 0; i < v.length; i++) {
    while (n >= v[i]) {
      b.write(s[i]);
      n -= v[i];
    }
  }
  return b.toString();
}


// ───────────────────────── KLASA 4 ─────────────────────────

Task m4Add(Random r) {
  final add = r.nextBool();
  late int a, b, c;
  if (add) {
    a = rng(r, 1000, 8500);
    b = rng(r, 100, 9999 - a);
    c = a + b;
  } else {
    a = rng(r, 2000, 9999);
    b = rng(r, 100, a - 500);
    c = a - b;
  }
  final op = add ? '+' : '−';
  return choice('m4_add', _m, 'Oblicz (możesz pisemnie)',
      intOpts(r, c, [c + 10, c - 10, c + 100, c - 100, c + 1000, c - 1], 4), '$c',
      speak: 'Ile to jest $a ${add ? 'dodać' : 'odjąć'} $b?',
      visual: '$a $op $b = ?',
      hint: 'Podpisz liczby jedna pod drugą: jedności pod jednościami.',
      explain: '$a $op $b = $c');
}

Task m4Mul(Random r) {
  final a = rng(r, 12, 999);
  final b = rng(r, 2, 9);
  final c = a * b;
  return choice('m4_mul', _m, 'Oblicz', intOpts(r, c, [c + b, c - b, c + 10, c - 10, c + 100], 4), '$c',
      speak: 'Ile to jest $a razy $b?',
      visual: '$a × $b = ?',
      hint: 'Pomnóż osobno setki, dziesiątki i jedności, potem dodaj.',
      explain: '$a × $b = $c');
}

Task m4Div(Random r) {
  final b = rng(r, 2, 9);
  final q = rng(r, 3, 30);
  final rem = r.nextInt(b);
  final a = b * q + rem;
  String f(int qq, int rr) => rr == 0 ? '$qq' : '$qq r. $rr';
  final correct = f(q, rem);
  final cands = <String>{f(q + 1, rem), f(q - 1, rem), f(q, (rem + 1) % b), f(q + 1, 0), f(q, rem == 0 ? 1 : 0)}
    ..remove(correct);
  final opts = shuffled(r, [correct, ...shuffled(r, cands.toList()).take(3)]);
  return choice('m4_div', _m, 'Podziel (z resztą)', opts, correct,
      speak: 'Ile to jest $a podzielić przez $b? Pamiętaj o reszcie.',
      visual: '$a : $b = ?',
      hint: 'Znajdź największą liczbę, która razy $b nie przekracza $a. Reszta jest mniejsza od $b.',
      explain: '$a = $b × $q${rem > 0 ? ' + $rem' : ''}');
}

Task m4Order(Random r) {
  switch (r.nextInt(4)) {
    case 0:
      final a = rng(r, 2, 20), b = rng(r, 2, 9), c = rng(r, 2, 9);
      final v = a + b * c;
      return choice('m4_order', _m, 'Oblicz (kolejność działań!)', intOpts(r, v, [(a + b) * c, v + 1, v - c], 4), '$v',
          visual: '$a + $b × $c', hint: 'Najpierw mnożenie, potem dodawanie.', explain: '$a + ${b * c} = $v');
    case 1:
      final a = rng(r, 2, 15), b = rng(r, 2, 9), c = rng(r, 2, 6);
      final v = (a + b) * c;
      return choice('m4_order', _m, 'Oblicz (kolejność działań!)', intOpts(r, v, [a + b * c, v + c, v - 1], 4), '$v',
          visual: '($a + $b) × $c', hint: 'Najpierw działanie w nawiasie.', explain: '${a + b} × $c = $v');
    case 2:
      final z = rng(r, 2, 9), q = rng(r, 2, 9), x = rng(r, q + 1, 50);
      final y = z * q;
      final v = x - q;
      return choice('m4_order', _m, 'Oblicz (kolejność działań!)', intOpts(r, v, [(x - y).abs(), v + 1, v + z], 4), '$v',
          visual: '$x − $y : $z', hint: 'Najpierw dzielenie, potem odejmowanie.', explain: '$x − $q = $v');
    default:
      final a = rng(r, 2, 9), b = rng(r, 2, 9), c = rng(r, 1, a * b - 1);
      final v = a * b - c;
      return choice('m4_order', _m, 'Oblicz (kolejność działań!)', intOpts(r, v, [a * (b - c), v + 1, v - 1, v + c], 4), '$v',
          visual: '$a × $b − $c', hint: 'Najpierw mnożenie, potem odejmowanie.', explain: '${a * b} − $c = $v');
  }
}

Task m4Roman(Random r) {
  final n = r.nextInt(3) == 0 ? rng(r, 1, 39) : rng(r, 40, 2100);
  final toRoman = r.nextBool();
  final cands = <int>{n + 1, n - 1, n + 10, n - 10, n + 5, n + 50, n - 4}..removeWhere((v) => v < 1 || v == n);
  final others = shuffled(r, cands.toList()).take(3).toList();
  if (toRoman) {
    return choice('m4_roman', _m, 'Jak zapiszesz tę liczbę cyframi rzymskimi?',
        shuffled(r, [roman(n), ...others.map(roman)]), roman(n),
        visual: '$n',
        hint: 'I=1, V=5, X=10, L=50, C=100, D=500, M=1000. Mniejsza przed większą – odejmujemy.',
        explain: '$n = ${roman(n)}');
  }
  return choice('m4_roman', _m, 'Jaka to liczba?', shuffled(r, ['$n', ...others.map((e) => '$e')]), '$n',
      visual: roman(n),
      hint: 'I=1, V=5, X=10, L=50, C=100, D=500, M=1000. Mniejsza przed większą – odejmujemy.',
      explain: '${roman(n)} = $n');
}

Task m4Frac(Random r) {
  final d = rng(r, 2, 10);
  final k = rng(r, 2, 12);
  final n = d * k;
  final mm = (d > 2 && r.nextInt(3) == 0) ? rng(r, 2, d - 1) : 1;
  final c = mm * k;
  return choice('m4_frac', _m, 'Oblicz', intOpts(r, c, [n ~/ 2, c + k, c - 1, n - c, d], 4), '$c',
      speak: 'Ile to jest $mm ${mm == 1 ? 'część' : 'części'} z $d z liczby $n?',
      visual: '$mm/$d z $n = ?',
      hint: 'Podziel $n na $d równych części${mm > 1 ? ' i weź $mm takie części' : ''}.',
      explain: '$n : $d = $k${mm > 1 ? ', $k × $mm = $c' : ''}');
}

Task m4Time(Random r) {
  final h = rng(r, 6, 18);
  final m = 5 * r.nextInt(12);
  final dur = 5 * rng(r, 3, 40);
  final end = h * 60 + m + dur;
  final eh = end ~/ 60, em = end % 60;
  return choice('m4_time', _m, 'Ile minut minęło?', intOpts(r, dur, [dur + 10, dur - 10, dur + 60, dur - 5, dur + 40], 4), '$dur',
      speak: 'Ile minut minęło od godziny $h:${two(m)} do $eh:${two(em)}?',
      visual: '$h:${two(m)} ➜ $eh:${two(em)}',
      hint: 'Doliczaj do pełnej godziny, a potem resztę. 1 godzina = 60 minut.',
      explain: '$dur min = ${dur ~/ 60} h ${dur % 60} min');
}

Task m4Perimeter(Random r) {
  if (r.nextBool()) {
    final a = rng(r, 2, 25), b = rng(r, 2, 25);
    final c = 2 * (a + b);
    return choice('m4_perimeter', _m, 'Jaki obwód ma prostokąt o bokach $a cm i $b cm?',
        intOpts(r, c, [a * b, a + b, c + 2, 2 * a + b], 4).map((e) => '$e cm').toList(), '$c cm',
        visual: '▭', hint: 'Obwód to suma długości wszystkich boków.', explain: '2 × $a + 2 × $b = $c cm');
  }
  final a = rng(r, 2, 30);
  final c = 4 * a;
  return choice('m4_perimeter', _m, 'Jaki obwód ma kwadrat o boku $a cm?',
      intOpts(r, c, [a * a, 2 * a, c + 4, 3 * a], 4).map((e) => '$e cm').toList(), '$c cm',
      visual: '◻', hint: 'Kwadrat ma 4 równe boki.', explain: '4 × $a = $c cm');
}

Task m4Word(Random r) {
  switch (r.nextInt(3)) {
    case 0:
      final n = rng(r, 2, 8), p = rng(r, 2, 9), x = rng(r, 2, 15);
      final c = n * p + x;
      return choice('m4_word', _m, 'Kupiłeś $n ${plural(n, 'zeszyt', 'zeszyty', 'zeszytów')} po $p zł i plecak za $x zł. Ile zapłaciłeś?',
          intOpts(r, c, [n * p, n + p + x, c + p, (n + 1) * p + x], 4), '$c',
          visual: '🛒', explain: '$n × $p + $x = $c zł');
    case 1:
      final t = rng(r, 10, 25), k = rng(r, 2, 5);
      final c = t * k;
      return choice('m4_word', _m, 'Rowerzysta jedzie $t km w ciągu godziny. Ile kilometrów przejedzie w $k godz.?',
          intOpts(r, c, [t + k, c + 1, t * (k + 1), c - t ~/ 2], 4), '$c',
          visual: '🚲', explain: '$t × $k = $c km');
    default:
      final total = rng(r, 4, 20) * 10, part = rng(r, 1, total ~/ 10 - 1) * 10;
      final c = total - part;
      return choice('m4_word', _m, 'Książka ma $total stron. Przeczytałeś już $part. Ile stron zostało?',
          intOpts(r, c, [total + part, c + 10, c - 10], 4), '$c',
          visual: '📚', explain: '$total − $part = $c');
  }
}

// ───────────────────────── KLASA 5 ─────────────────────────

Task m5FracAdd(Random r) {
  final d = rng(r, 3, 12);
  final a = rng(r, 1, d - 1);
  final add = r.nextBool();
  late int b, n;
  if (add) {
    b = rng(r, 1, d);
    n = a + b;
  } else {
    b = rng(r, 0, a);
    n = a - b;
  }
  final op = add ? '+' : '−';
  return choice('m5_frac_add', _m, 'Oblicz', fracOpts(r, [n, d], [[n, 2 * d], [a * b, d], [n + 1, d], [n - 1, d], [n, d + 1]], 4), fs(n, d),
      speak: 'Oblicz: $a przez $d ${add ? 'dodać' : 'odjąć'} $b przez $d',
      visual: '$a/$d $op $b/$d = ?',
      hint: 'Przy tych samych mianownikach ${add ? 'dodajemy' : 'odejmujemy'} tylko liczniki.',
      explain: '$a/$d $op $b/$d = $n/$d${fs(n, d) != '$n/$d' ? ' = ${fs(n, d)}' : ''}');
}

Task m5FracCmp(Random r) {
  final d1 = rng(r, 2, 10), d2 = rng(r, 2, 10);
  final a = rng(r, 1, d1), b = rng(r, 1, d2);
  final x = a * d2, y = b * d1;
  final c = x > y ? '>' : (x < y ? '<' : '=');
  return choice('m5_frac_cmp', _m, 'Który znak pasuje?', const ['<', '=', '>'], c,
      visual: '$a/$d1   ?   $b/$d2',
      hint: 'Sprowadź ułamki do wspólnego mianownika ${d1 * d2}.',
      explain: '$x/${d1 * d2} $c $y/${d1 * d2}');
}

Task m5Reduce(Random r) {
  late int a, b;
  do {
    b = rng(r, 2, 12);
    a = rng(r, 1, b - 1);
  } while (gcd(a, b) != 1);
  final k = rng(r, 2, 9);
  return choice('m5_reduce', _m, 'Skróć ułamek', fracOpts(r, [a, b], [[a + 1, b], [a, b + 1], [a * k, b], [a, b * k], [b, a]], 4), fs(a, b),
      visual: '${a * k}/${b * k}',
      hint: 'Podziel licznik i mianownik przez tę samą liczbę.',
      explain: '${a * k}/${b * k} = $a/$b (dzielimy przez $k)');
}

Task m5Dec(Random r) {
  final add = r.nextBool();
  final a = rng(r, 10, 2000);
  final b = rng(r, 10, add ? 2000 : a);
  final c = add ? a + b : a - b;
  final op = add ? '+' : '−';
  return choice('m5_dec', _m, 'Oblicz', decOpts(r, c, [c + 10, c - 10, c + 100, c - 1, c + 1], 4), dec(c),
      visual: '${dec(a)} $op ${dec(b)} = ?',
      hint: 'Podpisz liczby przecinek pod przecinkiem.',
      explain: '${dec(a)} $op ${dec(b)} = ${dec(c)}');
}

Task m5Divisible(Random r) {
  final k = pick(r, const [2, 3, 4, 5, 9, 10]);
  final good = k * rng(r, 11, 300);
  final wrong = <int>{};
  while (wrong.length < 3) {
    final v = rng(r, 100, 3000);
    if (v % k != 0) wrong.add(v);
  }
  final rules = {
    2: 'ostatnia cyfra parzysta',
    3: 'suma cyfr podzielna przez 3',
    4: 'liczba z dwóch ostatnich cyfr podzielna przez 4',
    5: 'ostatnia cyfra 0 lub 5',
    9: 'suma cyfr podzielna przez 9',
    10: 'ostatnia cyfra 0',
  };
  return choice('m5_divisible', _m, 'Która liczba jest podzielna przez $k?',
      shuffled(r, ['$good', ...wrong.map((e) => '$e')]), '$good',
      hint: 'Cecha podzielności przez $k: ${rules[k]}.', explain: '$good : $k = ${good ~/ k}');
}

Task m5Area(Random r) {
  switch (r.nextInt(3)) {
    case 0:
      final a = rng(r, 2, 15), b = rng(r, 2, 15);
      final c = a * b;
      return choice('m5_area', _m, 'Jakie pole ma prostokąt o bokach $a cm i $b cm?',
          intOpts(r, c, [2 * (a + b), a + b, c + a], 4).map((e) => '$e cm²').toList(), '$c cm²',
          visual: '▭', hint: 'Pole prostokąta = a × b.', explain: '$a × $b = $c cm²');
    case 1:
      final a = rng(r, 2, 15) * 2, h = rng(r, 2, 15);
      final c = a * h ~/ 2;
      return choice('m5_area', _m, 'Jakie pole ma trójkąt o podstawie $a cm i wysokości $h cm?',
          intOpts(r, c, [a * h, a + h, c + h], 4).map((e) => '$e cm²').toList(), '$c cm²',
          visual: '△', hint: 'Pole trójkąta = (a × h) : 2.', explain: '$a × $h : 2 = $c cm²');
    default:
      final a = rng(r, 2, 15), h = rng(r, 2, 15);
      final c = a * h;
      return choice('m5_area', _m, 'Jakie pole ma równoległobok o boku $a cm i wysokości $h cm opuszczonej na ten bok?',
          intOpts(r, c, [a * h ~/ 2, 2 * (a + h), c + a], 4).map((e) => '$e cm²').toList(), '$c cm²',
          visual: '▱', hint: 'Pole równoległoboku = a × h.', explain: '$a × $h = $c cm²');
  }
}

Task m5Powers(Random r) {
  final cube = r.nextInt(3) == 0;
  final a = cube ? rng(r, 2, 6) : rng(r, 2, 15);
  final c = cube ? a * a * a : a * a;
  return choice('m5_powers', _m, 'Oblicz potęgę', intOpts(r, c, [a * (cube ? 3 : 2), c + a, c - a, a * a * (cube ? 1 : a)], 4), '$c',
      visual: '$a${cube ? '³' : '²'} = ?',
      hint: cube ? '$a³ = $a × $a × $a' : '$a² = $a × $a',
      explain: cube ? '$a × $a × $a = $c' : '$a × $a = $c');
}

Task m5Angles(Random r) {
  if (r.nextBool()) {
    final a = rng(r, 25, 100), b = rng(r, 20, 150 - a);
    final c = 180 - a - b;
    return choice('m5_angles', _m, 'Dwa kąty trójkąta mają $a° i $b°. Ile ma trzeci kąt?',
        intOpts(r, c, [360 - a - b, c + 10, 90 - a > 0 ? 90 - a : c + 20], 4).map((e) => '$e°').toList(), '$c°',
        visual: '△', hint: 'Suma kątów w trójkącie wynosi 180°.', explain: '180° − $a° − $b° = $c°');
  }
  final kinds = [
    [rng(r, 10, 89), 'ostry'],
    [90, 'prosty'],
    [rng(r, 91, 179), 'rozwarty'],
    [180, 'półpełny'],
  ];
  final k = pick(r, kinds);
  return choice('m5_angles', _m, 'Jaki to kąt?', const ['ostry', 'prosty', 'rozwarty', 'półpełny'], k[1] as String,
      visual: '${k[0]}°', hint: 'Ostry < 90°, prosty = 90°, rozwarty między 90° a 180°, półpełny = 180°.',
      explain: '${k[0]}° to kąt ${k[1]}');
}

// ───────────────────────── KLASA 6 ─────────────────────────

Task m6FracMul(Random r) {
  final a = rng(r, 1, 6), b = rng(r, 2, 9), c = rng(r, 1, 6), d = rng(r, 2, 9);
  final mul = r.nextBool();
  final n = mul ? a * c : a * d;
  final m = mul ? b * d : b * c;
  final op = mul ? '×' : ':';
  return choice('m6_frac_muldiv', _m, 'Oblicz',
      fracOpts(r, [n, m], [[a * c, b + d], [a + c, b * d], [a * d, b * c], [a * c, b * d], [n + 1, m]], 4), fs(n, m),
      visual: '$a/$b $op $c/$d = ?',
      hint: mul ? 'Mnożymy licznik przez licznik, mianownik przez mianownik.' : 'Dzielenie = mnożenie przez odwrotność drugiego ułamka.',
      explain: '$a/$b $op $c/$d = ${fs(n, m)}');
}

Task m6Neg(Random r) {
  final a = rng(r, -20, 20), b = rng(r, -20, 20);
  final add = r.nextBool();
  final c = add ? a + b : a - b;
  final op = add ? '+' : '−';
  return choice('m6_neg', _m, 'Oblicz', intOpts(r, c, [-c, add ? a - b : a + b, c + 1, c - 1], 4), sn(c),
      visual: '${sn(a)} $op ${sp(b)} = ?',
      hint: 'Pomyśl o osi liczbowej. Odejmowanie liczby ujemnej to dodawanie przeciwnej.',
      explain: '${sn(a)} $op ${sp(b)} = ${sn(c)}');
}

Task m6DecMul(Random r) {
  final a = rng(r, 2, 99); // dziesiąte
  final b = rng(r, 2, 9);
  final c = a * b * 10; // w setnych
  return choice('m6_dec_mul', _m, 'Oblicz', decOpts(r, c, [c * 10, c ~/ 10, c + 100, c - 10], 4), dec(c),
      visual: '${dec(a * 10)} × $b = ?',
      hint: 'Pomnóż bez przecinka, potem oddziel tyle miejsc po przecinku, ile było.',
      explain: '${dec(a * 10)} × $b = ${dec(c)}');
}

Task m6Expr(Random r) {
  final a = rng(r, 2, 9), b = rng(r, -10, 15), x = rng(r, -5, 10);
  final c = a * x + b;
  final bs = b < 0 ? '− ${-b}' : '+ $b';
  return choice('m6_expr', _m, 'Oblicz wartość wyrażenia dla x = ${sn(x)}', intOpts(r, c, [a + x + b, a * x - b, c + a, c - 1], 4), sn(c),
      visual: '${a}x $bs',
      hint: '${a}x oznacza $a × x. Podstaw ${sn(x)} w miejsce x.',
      explain: '$a × ${sp(x)} $bs = ${sn(c)}');
}

Task m6Volume(Random r) {
  if (r.nextInt(3) == 0) {
    final a = rng(r, 2, 10);
    final c = a * a * a;
    return choice('m6_volume', _m, 'Jaką objętość ma sześcian o krawędzi $a cm?',
        intOpts(r, c, [6 * a * a, a * a, 12 * a], 4).map((e) => '$e cm³').toList(), '$c cm³',
        visual: '🧊', hint: 'V = a × a × a', explain: '$a × $a × $a = $c cm³');
  }
  final a = rng(r, 2, 12), b = rng(r, 2, 10), h = rng(r, 2, 10);
  final c = a * b * h;
  return choice('m6_volume', _m, 'Jaką objętość ma prostopadłościan o wymiarach $a cm × $b cm × $h cm?',
      intOpts(r, c, [a + b + h, 2 * (a * b + a * h + b * h), a * b, c + a * b], 4).map((e) => '$e cm³').toList(), '$c cm³',
      visual: '📦', hint: 'V = a × b × h', explain: '$a × $b × $h = $c cm³');
}

Task m6Mean(Random r) {
  final n = rng(r, 3, 5);
  final mean = rng(r, 3, 20);
  final xs = <int>[];
  for (int i = 0; i < n - 1; i++) {
    xs.add(mean + rng(r, -4, 4));
  }
  xs.add(mean * n - xs.fold<int>(0, (a, b) => a + b));
  final sum = mean * n;
  return choice('m6_mean', _m, 'Oblicz średnią arytmetyczną liczb', intOpts(r, mean, [sum, mean + 1, mean - 1, xs[n ~/ 2]], 4), '$mean',
      visual: xs.map(sn).join(', '),
      hint: 'Dodaj wszystkie liczby i podziel przez ich ilość ($n).',
      explain: '$sum : $n = $mean');
}

// ───────────────────────── KLASA 7 ─────────────────────────

Task m7Percent(Random r) {
  final p = pick(r, const [5, 10, 20, 25, 30, 40, 50, 60, 75, 15]);
  final base = 20 * rng(r, 1, 30);
  final c = base * p ~/ 100;
  if (r.nextInt(3) == 0) {
    final up = r.nextBool();
    final v = up ? base + c : base - c;
    return choice('m7_percent', _m,
        'Cena ${base} zł ${up ? 'wzrosła' : 'spadła'} o $p%. Ile wynosi nowa cena?',
        intOpts(r, v, [c, up ? base - c : base + c, base + p, v + 10], 4).map((e) => '$e zł').toList(), '$v zł',
        visual: up ? '📈' : '🏷️', hint: 'Oblicz $p% z $base i ${up ? 'dodaj' : 'odejmij'}.',
        explain: '$p% z $base = $c; $base ${up ? '+' : '−'} $c = $v zł');
  }
  return choice('m7_percent', _m, 'Oblicz', intOpts(r, c, [base * p ~/ 10, c + 10, base - c, p], 4), '$c',
      visual: '$p% z $base = ?', hint: '1% to setna część liczby. $p% = $p/100.', explain: '$base × $p/100 = $c');
}

Task m7Powers(Random r) {
  switch (r.nextInt(3)) {
    case 0:
      final a = pick(r, const [2, 3, 5, 10]);
      final n = a == 2 ? rng(r, 3, 8) : (a == 10 ? rng(r, 2, 6) : rng(r, 2, 4));
      var c = 1;
      for (int i = 0; i < n; i++) {
        c *= a;
      }
      return choice('m7_powers', _m, 'Oblicz potęgę', intOpts(r, c, [a * n, c * a, c ~/ a, c + 1], 4), '$c',
          visual: '$a^$n = ?', hint: '$a^$n to $a pomnożone przez siebie $n razy.', explain: '$a^$n = $c');
    case 1:
      final a = rng(r, 2, 7), m = rng(r, 2, 8), n = rng(r, 2, 8);
      final c = m + n;
      return choice('m7_powers', _m, 'Jaki będzie wykładnik?', intOpts(r, c, [m * n, (m - n).abs(), c + 1], 4).map((e) => '$a^$e').toList(), '$a^$c',
          visual: '$a^$m · $a^$n = ?', hint: 'Przy mnożeniu potęg o tej samej podstawie dodajemy wykładniki.', explain: '$a^($m+$n) = $a^$c');
    default:
      final a = rng(r, 2, 7), m = rng(r, 2, 8), n = rng(r, 2, 4);
      final c = m * n;
      return choice('m7_powers', _m, 'Jaki będzie wykładnik?', intOpts(r, c, [m + n, c + 1, c - 1], 4).map((e) => '$a^$e').toList(), '$a^$c',
          visual: '($a^$m)^$n = ?', hint: 'Potęgując potęgę, mnożymy wykładniki.', explain: '$a^($m·$n) = $a^$c');
  }
}

Task m7Roots(Random r) {
  final cube = r.nextInt(3) == 0;
  final k = cube ? rng(r, 1, 10) : rng(r, 1, 20);
  final v = cube ? k * k * k : k * k;
  return choice('m7_roots', _m, 'Oblicz pierwiastek', intOpts(r, k, [v ~/ 2, k + 1, k - 1, k * 2], 4), '$k',
      visual: cube ? '∛$v = ?' : '√$v = ?',
      hint: cube ? 'Jaka liczba podniesiona do sześcianu daje $v?' : 'Jaka liczba podniesiona do kwadratu daje $v?',
      explain: cube ? '$k³ = $v' : '$k² = $v');
}

Task m7Equation(Random r) {
  final a = rng(r, 2, 9), x = rng(r, -6, 12), b = rng(r, -15, 20);
  final c = a * x + b;
  final bs = b < 0 ? '− ${-b}' : '+ $b';
  return choice('m7_equation', _m, 'Rozwiąż równanie', intOpts(r, x, [x + 1, x - 1, -x, (c + b) ~/ a], 4).map((e) => 'x = $e').toList(), 'x = ${sn(x)}',
      visual: '${a}x $bs = ${sn(c)}',
      hint: 'Przenieś liczbę na drugą stronę (zmieniając znak), potem podziel przez $a.',
      explain: '${a}x = ${sn(c - b)}, więc x = ${sn(x)}');
}

Task m7Simplify(Random r) {
  final a = rng(r, 2, 9), b = rng(r, 1, 9), c = rng(r, 1, 9);
  final v = a + b - c;
  String t(int k) => k == 1 ? 'x' : (k == -1 ? '−x' : (k == 0 ? '0' : '${sn(k)}x'));
  final opts = <String>{t(v), t(a + b + c), t(a - b + c), '${t(v)}²', t(v + 1)}.toList();
  return choice('m7_simplify', _m, 'Uprość wyrażenie', shuffled(r, [t(v), ...shuffled(r, opts.where((o) => o != t(v)).toList()).take(3)]), t(v),
      visual: '${a}x + ${b}x − ${c}x',
      hint: 'To wyrazy podobne – dodajemy i odejmujemy same współczynniki.',
      explain: '$a + $b − $c = $v, więc ${t(v)}');
}

Task m7Proportion(Random r) {
  final a = rng(r, 2, 12), b = rng(r, 2, 12), k = rng(r, 2, 6);
  final c = a * k, x = b * k;
  return choice('m7_proportion', _m, 'Rozwiąż proporcję', intOpts(r, x, [x + k, b + k, c, x - 1], 4).map((e) => 'x = $e').toList(), 'x = $x',
      visual: '$a : $b = $c : x',
      hint: 'W proporcji iloczyn wyrazów skrajnych równa się iloczynowi środkowych.',
      explain: '$a · x = $b · $c, x = $x');
}

// ───────────────────────── KLASA 8 ─────────────────────────

Task m8Pythagoras(Random r) {
  final t = pick(r, const [
    [3, 4, 5], [6, 8, 10], [5, 12, 13], [8, 15, 17], [9, 12, 15], [7, 24, 25], [12, 16, 20], [9, 40, 41], [15, 20, 25]
  ]);
  if (r.nextBool()) {
    return choice('m8_pythagoras', _m, 'Przyprostokątne trójkąta prostokątnego mają ${t[0]} i ${t[1]}. Ile ma przeciwprostokątna?',
        intOpts(r, t[2], [t[0] + t[1], t[2] + 1, t[2] - 1, t[1] + 2], 4), '${t[2]}',
        visual: '◺', hint: 'a² + b² = c²', explain: '${t[0]}² + ${t[1]}² = ${t[0] * t[0] + t[1] * t[1]} = ${t[2]}²');
  }
  return choice('m8_pythagoras', _m, 'Przeciwprostokątna ma ${t[2]}, jedna przyprostokątna ${t[0]}. Ile ma druga przyprostokątna?',
      intOpts(r, t[1], [t[2] - t[0], t[1] + 1, t[1] - 2, t[2] + t[0]], 4), '${t[1]}',
      visual: '◺', hint: 'b² = c² − a²', explain: '${t[2]}² − ${t[0]}² = ${t[1] * t[1]} = ${t[1]}²');
}

Task m8Circle(Random r) {
  final rr = rng(r, 2, 12);
  if (r.nextBool()) {
    return choice('m8_circle', _m, 'Jakie pole ma koło o promieniu $rr cm?',
        shuffled(r, ['${rr * rr}π cm²', '${2 * rr}π cm²', '${rr}π cm²', '${4 * rr * rr}π cm²']), '${rr * rr}π cm²',
        visual: '⚪', hint: 'P = πr²', explain: 'π × $rr² = ${rr * rr}π cm²');
  }
  return choice('m8_circle', _m, 'Jaki obwód ma okrąg o promieniu $rr cm?',
      shuffled(r, ['${2 * rr}π cm', '${rr * rr}π cm', '${rr}π cm', '${4 * rr}π cm']), '${2 * rr}π cm',
      visual: '⭕', hint: 'L = 2πr', explain: '2 × π × $rr = ${2 * rr}π cm');
}

Task m8Probability(Random r) {
  final a = rng(r, 1, 9), b = rng(r, 1, 9);
  final colors = pick(r, const [
    ['czerwonych', 'niebieskich', 'czerwoną'],
    ['zielonych', 'żółtych', 'zieloną'],
    ['białych', 'czarnych', 'białą'],
  ]);
  return choice('m8_probability', _m,
      'W pudełku jest $a ${colors[0]} i $b ${colors[1]} kul. Jakie jest prawdopodobieństwo, że wylosujesz ${colors[2]}?',
      fracOpts(r, [a, a + b], [[a, b], [b, a + b], [1, a + b], [1, 2], [a + 1, a + b]], 4), fs(a, a + b),
      visual: '🎱', hint: 'Prawdopodobieństwo = liczba zdarzeń sprzyjających : liczba wszystkich zdarzeń.',
      explain: '$a : ${a + b} = ${fs(a, a + b)}');
}

Task m8Square(Random r) {
  final a = rng(r, 2, 15);
  if (r.nextBool()) {
    return choice('m8_irrational', _m, 'Jaką długość ma przekątna kwadratu o boku $a?',
        shuffled(r, ['$a√2', '$a√3', '${2 * a}', '${a * a}']), '$a√2',
        visual: '◇', hint: 'Przekątna kwadratu: d = a√2', explain: 'd = $a√2');
  }
  return choice('m8_irrational', _m, 'Jaką wysokość ma trójkąt równoboczny o boku ${2 * a}?',
      shuffled(r, ['$a√3', '${2 * a}√3', '$a√2', '${2 * a}']), '$a√3',
      visual: '△', hint: 'Wysokość trójkąta równobocznego: h = a√3 / 2', explain: 'h = ${2 * a}√3 / 2 = $a√3');
}

Task m8Prism(Random r) {
  final a = rng(r, 2, 10), h = rng(r, 2, 15);
  if (r.nextBool()) {
    final c = a * a * h;
    return choice('m8_solids', _m, 'Jaką objętość ma graniastosłup prawidłowy czworokątny o krawędzi podstawy $a cm i wysokości $h cm?',
        intOpts(r, c, [4 * a * h, a * h, c + a * a], 4).map((e) => '$e cm³').toList(), '$c cm³',
        visual: '🏢', hint: 'V = pole podstawy × wysokość', explain: '$a² × $h = $c cm³');
  }
  final c = a * a * h; // ostrosłup: (1/3)·a²·H, dobieramy H podzielne przez 3
  final hh = 3 * h;
  return choice('m8_solids', _m, 'Jaką objętość ma ostrosłup prawidłowy czworokątny o krawędzi podstawy $a cm i wysokości $hh cm?',
      intOpts(r, c, [a * a * hh, c * 2, c + a], 4).map((e) => '$e cm³').toList(), '$c cm³',
      visual: '🔺', hint: 'V = ⅓ × pole podstawy × wysokość', explain: '⅓ × $a² × $hh = $c cm³');
}
