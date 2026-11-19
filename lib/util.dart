import 'dart:math';

String two(int n) => n < 10 ? '0$n' : '$n';

String dayKey(DateTime d) => '${d.year}-${two(d.month)}-${two(d.day)}';

String todayKey() => dayKey(DateTime.now());

/// Klucz tygodnia = data poniedziałku danego tygodnia.
String weekKey(DateTime d) {
  final monday = DateTime(d.year, d.month, d.day - (d.weekday - 1));
  return dayKey(monday);
}

/// Losowa liczba całkowita z przedziału [a, b].
int rng(Random r, int a, int b) => b <= a ? a : a + r.nextInt(b - a + 1);

T pick<T>(Random r, List<T> l) => l[r.nextInt(l.length)];

List<T> shuffled<T>(Random r, List<T> l) => List<T>.of(l)..shuffle(r);

List<T> pickN<T>(Random r, List<T> l, int n) => shuffled(r, l).take(n).toList();

/// Polska odmiana liczebników: 1 kot, 2 koty, 5 kotów.
String plural(int n, String one, String few, String many) {
  if (n == 1) return one;
  final d = n % 10;
  final h = n % 100;
  if (d >= 2 && d <= 4 && (h < 12 || h > 14)) return few;
  return many;
}

/// Kolejność liter polskiego alfabetu.
const String _abc = 'aąbcćdeęfghijklłmnńoópqrsśtuvwxyzźż';

int plCompare(String a, String b) {
  final x = a.toLowerCase();
  final y = b.toLowerCase();
  final n = min(x.length, y.length);
  for (int i = 0; i < n; i++) {
    final ia = _abc.indexOf(x[i]);
    final ib = _abc.indexOf(y[i]);
    final va = ia < 0 ? 1000 + x.codeUnitAt(i) : ia;
    final vb = ib < 0 ? 1000 + y.codeUnitAt(i) : ib;
    if (va != vb) return va - vb;
  }
  return x.length - y.length;
}
